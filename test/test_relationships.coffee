{App, Backbone} = require "./fixtures"

Backbone.Benefits.register(App)

test = (name, fn) ->
  exports[name] = (test) ->
    fn.call(test)
    test.done()


test "hasMany", ->
  todos = App.todolists.get(1).todos()
  @equal todos.constructor, App.collections.Todos
  @deepEqual todos.pluck("id"), [1, 2]

  todos = App.todolists.get(2).todos()
  @deepEqual todos.pluck("id"), [3]


test "hasMany with 'modelName' option", ->
  todos = App.todolists.get(2).items()
  @deepEqual todos.pluck("id"), [3]


test "hasMany with 'collectionName' option", ->
  todos = App.todolists.get(2).tasks()
  @deepEqual todos.pluck("id"), [3]


test "hasMany with 'conditions' option", ->
  todos = App.todolists.get(1).importantTodos()
  @deepEqual todos.pluck("id"), [2]


test "hasMany with foreignKey option", ->
  comments = App.users.get(1).comments()
  @deepEqual comments.pluck("id"), [1]


test "hasMany with 'as' option", ->
  comments = App.todos.get(2).comments()
  @deepEqual comments.pluck("id"), [1]


test "hasMany with 'through' option", ->
  projects = App.users.get(1).projects()
  @deepEqual projects.pluck("id"), [1]


test "hasMany with 'through' and 'conditions' options", ->
  projects = App.users.get(2).adminProjects()
  @deepEqual projects.pluck("id"), [2]


test "hasMany with 'through' and 'source' options", ->
  users = App.projects.get(2).people()
  @deepEqual users.pluck("id"), [2]


test "model changes in a hasMany filtered collection", ->
  changed = false
  App.todos.on("change", -> changed = true)
  App.todolists.get(1).todos().first().set("name", "Do it")
  @ok changed


test "collection options for a hasMany filtered collection", ->
  comparator = ->
  @equal App.todolists.get(1).todos({comparator}).comparator, comparator


test "belongsTo", ->
  @equal App.todos.get(1).todolist(), App.todolists.get(1)
  @equal App.todos.get(3).todolist(), App.todolists.get(2)


test "belongsTo with modelName option", ->
  @equal App.comments.get(1).creator(), App.users.get(1)


test "belongsTo with 'collectionName' option", ->
  @equal App.todos.get(1).list(), App.todolists.get(1)


test "belongsTo with polymorphic option", ->
  @equal App.comments.get(1).commentable(), App.todos.get(2)


test "belongsTo with blank association attributes", ->
  todo = App.todos.get(1)
  todo.unset("todolist_id")
  @equal todo.todolist(), null

  comment = App.comments.get(1)
  comment.unset("commentable_type")
  comment.unset("commentable_id")
  @equal comment.commentable(), null

