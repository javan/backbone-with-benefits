## Backbone with Benefits: Casual Relationships

An ActiveRecord-inspired interface for declaring and traversing relationships between Backbone models. Backbone with Benefits derives associations from [bootstrapped](http://documentcloud.github.io/backbone/#FAQ-bootstrap) or already-fetched collections. It expects these collections to be defined on a single object and named following a similar convention to database tables (e.g. `MyApp.todos` for a collection of `Todo` models).

_All code samples in this document are written in CoffeeScript._

### Installation

1. Load `backbone-with-benefits[-min].js` after `backbone.js`

2. Register your bootstrapped collections object: `Backbone.Benefits.register(MyApp)`

### Examples

#### ♥︎ Model.hasMany

```coffee
class Todolist extends Backbone.Model
  @hasMany "todos"
```

```
〉todolist.todos()
  ‣ Todos {length: 4, models: Array[4], ...}

〉todolist.todos().toArray()
 [‣ Todo, ‣ Todo, ‣ Todo, ‣ Todo]
```

Defines a `todos` method on instances of `Todolist` (`Todolist.prototype`) that returns a new `Backbone.Collection` of the same type (e.g. `MyApp.collections.Todos`) containing `Todo` models with a `todolist_id` attribute matching the `Todolist` model's `id`. Expects a collection of `Todo` models defined on the `todos` property of the registered object (e.g. `MyApp.todos`).

#### ♥︎ Model.hasMany with `foreignKey` option

```coffee
class User extends Backbone.Model
  @hasMany "comments", foreignKey: "creator_id"
```

Defines a `comments` method that returns a collection of `Comment` models with a `creator_id` attribute matching the `User` model's `id`.

#### ♥︎ Model.hasMany with `as` option

```coffee
class Todo extends Backbone.Model
  @hasMany "comments", as: "commentable"
```

Defines a `comments` method that returns a collection of `Comment` models with a `commentable_type` attribute of "Todo" and a `commentable_id` attribute matching the `Todo` model's `id`.

#### ♥︎ Model.belongsTo

```coffee
class Todo extends Backbone.Model
  @belongsTo "todolist"
```

Defines a `todolist` method that returns the `Todo` model with `todolist_id` attribute matching the `Todolist` model's `id`. Expects a `Todolist` model collection defined on the `todolists` property of the registered object.

#### ♥︎ Model.belongsTo with `modelName` option

```coffee
class Comment extends Backbone.Model
  @belongsTo "creator", modelName: "User"
```

Defines a `creator` method that returns the `User` model with an `id` matching the `Comment` model's `creator_id` attribute. Expects a `User` model collection defined on the `users` property of the registered object.

#### ♥︎ Model.belongsTo with `polymorphic` option

```coffee
class Comment extends Backbone.Model
  @belongsTo "commentable", polymorphic: true

new Comment(commentable_type: "Todo", commentable_id: 1).commentable()
# Returns a `Todo` model
```

Defines a `commentable` method that returns the model corresponding to the `Comment` model's `commentable_type` and `commentable_id` attributes.

---

Copyright (c) 2014 Javan Makhmali
