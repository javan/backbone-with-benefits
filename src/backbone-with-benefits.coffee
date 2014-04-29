if exports?
  do ->
    @_ = require "underscore"
    exports.Backbone = @Backbone = require "backbone"


Backbone.Benefits =
  db: {}
  register: (@db) ->


_.extend Backbone.Model,
  hasMany: (associationName, {foreignKey, as, through, conditions, modelName, collectionName} = {}) ->
    @::[decapitalize(associationName)] = (collectionOptions) ->
      collectionName ?= modelName ? associationName
      conditions ?= {}

      thisModelName = getModelName(@constructor)
      collection = findCollection(collectionName)

      switch
        when foreignKey
          conditions[foreignKey] = @id
        when as
          conditions["#{as}_type"] = thisModelName
          conditions["#{as}_id"] = @id
        else
          foreignKey = getForeignKey(thisModelName)
          conditions[foreignKey] = @id

      models =
        if through?
          _(@[through]().where(conditions)).invoke(singularize(collectionName))
        else
          collection.where(conditions)

      new collection.constructor models, collectionOptions

  belongsTo: (associationName, {modelName, polymorphic} = {}) ->
    @::[decapitalize(associationName)] = ->
      switch
        when polymorphic
          collectionName = @get("#{associationName}_type")
          foreignKey = "#{associationName}_id"
        when modelName
          collectionName = modelName
          foreignKey = getForeignKey(associationName)
        else
          collectionName = associationName
          foreignKey = getForeignKey(associationName)

      if collectionName? and foreignKey?
        findCollection(collectionName).get(@get(foreignKey))


# Helpers


findCollection = (name) ->
  possibleNames = [name, pluralize(name), decapitalize(pluralize(name))]

  for possibleName in possibleNames
    return collection if collection = Backbone.Benefits.db[possibleName]

getModelName = (model) ->
  model.modelName ? model.name ? model.toString().match(/function\s*(\w+)/)?[1]

getForeignKey = (string) ->
  underscore(singularize(string)) + "_id"

underscore = (string) ->
  string.replace(/([a-z\d])([A-Z]+)/g, "$1_$2").replace(/[-\s]+/g, "_").toLowerCase()

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.substring(1)

decapitalize = (string) ->
  string.charAt(0).toLowerCase() + string.substring(1)

pluralize = (string) ->
  string.replace(/([^s])$/, "$1s")

singularize = (string) ->
  string.replace(/s$/, "")
