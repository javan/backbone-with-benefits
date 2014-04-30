{Backbone} = require "../src/backbone-with-benefits"

App =
  collections: {}
  models: {}

class App.models.Todolist extends Backbone.Model
  @hasMany "todos"
  @hasMany "items", modelName: "Todo"
  @hasMany "tasks", collectionName: "todos"
  @hasMany "importantTodos", modelName: "todo", conditions: { important: true }

class App.collections.Todolists extends Backbone.Collection
  model: App.models.Todolist

class App.models.Todo extends Backbone.Model
  @belongsTo "todolist"
  @belongsTo "list", collectionName: "todolists"
  @hasMany "comments", as: "commentable"

class App.collections.Todos extends Backbone.Collection
  model: App.models.Todo

class App.models.Comment extends Backbone.Model
  @belongsTo "creator", modelName: "User"
  @belongsTo "commentable", polymorphic: true

class App.collections.Comments extends Backbone.Collection
  model: App.models.Comment

class App.models.User extends Backbone.Model
  @hasMany "comments", foreignKey: "creator_id"
  @hasMany "accesses"
  @hasMany "projects", through: "accesses"
  @hasMany "adminProjects", through: "accesses", collectionName: "projects", conditions: { admin: true }

class App.collections.Users extends Backbone.Collection
  model: App.models.User

class App.models.Access extends Backbone.Model
  @belongsTo "user"
  @belongsTo "project"

class App.collections.Accesses extends Backbone.Collection
  model: App.models.Access

class App.models.Project extends Backbone.Model
  @hasMany "accesses"
  @hasMany "people", through: "accesses", source: "user"

class App.collections.Projects extends Backbone.Collection
  model: App.models.Project

class App.models.Octopus extends Backbone.Model
  @hasMany "children"

class App.collections.Octopi extends Backbone.Collection
  model: App.models.Octopus

class App.models.Child extends Backbone.Model
  @belongsTo "octopus", collectionName: "octopi", foreignKey: "octopus_id"

class App.collections.Children extends Backbone.Collection
  model: App.models.Child


App.todolists =
  new App.collections.Todolists [
    { id: 1 }
    { id: 2 }
  ]

App.todos =
  new App.collections.Todos [
    { id: 1, todolist_id: 1 }
    { id: 2, todolist_id: 1, important: true }
    { id: 3, todolist_id: 2, important: true }
  ]

App.users =
  new App.collections.Users [
    { id: 1 }
    { id: 2 }
  ]

App.comments =
  new App.collections.Comments [
    { id: 1, creator_id: 1, commentable_type: "Todo", commentable_id: 2 }
  ]

App.accesses =
  new App.collections.Accesses [
    { user_id: 1, project_id: 1 }
    { user_id: 2, project_id: 1 }
    { user_id: 2, project_id: 2, admin: true }
  ]

App.projects =
  new App.collections.Projects [
    { id: 1 },
    { id: 2 }
  ]

App.octopi =
  new App.collections.Octopi [
    { id: 1 }
  ]

App.children =
  new App.collections.Children [
    { id: 1, octopus_id: 1 }
  ]

exports.App = App
exports.Backbone = Backbone
