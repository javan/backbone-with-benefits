{Backbone} = require "../src/backbone-with-benefits"

App =
  collections: {}
  models: {}

class App.models.Todolist extends Backbone.Model
  @hasMany "todos"

class App.collections.Todolists extends Backbone.Collection
  model: App.models.Todolist

class App.models.Todo extends Backbone.Model
  @belongsTo "todolist"
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

class App.collections.Users extends Backbone.Collection
  model: App.models.User


App.todolists =
  new App.collections.Todolists [
    { id: 1 }
    { id: 2 }
  ]

App.todos =
  new App.collections.Todos [
    { id: 1, todolist_id: 1 }
    { id: 2, todolist_id: 1 }
    { id: 3, todolist_id: 2 }
  ]

App.users =
  new App.collections.Users [
    { id: 1 }
  ]

App.comments =
  new App.collections.Comments [
    { id: 1, creator_id: 1, commentable_type: "Todo", commentable_id: 2 }
  ]

exports.App = App
exports.Backbone = Backbone
