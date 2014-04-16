// Backbone with Benefits 0.1.0 (https://github.com/javan/backbone-with-benefits)
// Copyright (c) 2014 Javan Makhmali <javan@javan.us> (http://javan.us)
// MIT license (http://opensource.org/licenses/MIT)
(function() {
  var capitalize, decapitalize, findCollection, getForeignKey, getModelName, pluralize, singularize, underscore;

  if (typeof exports !== "undefined" && exports !== null) {
    (function() {
      this._ = require("underscore");
      return exports.Backbone = this.Backbone = require("backbone");
    })();
  }

  Backbone.Benefits = {
    db: {},
    register: function(db) {
      this.db = db;
    }
  };

  _.extend(Backbone.Model, {
    hasMany: function(collectionName, _arg) {
      var as, foreignKey, _ref;
      _ref = _arg != null ? _arg : {}, foreignKey = _ref.foreignKey, as = _ref.as;
      return this.prototype[decapitalize(collectionName)] = function(collectionOptions) {
        var collection, conditions, modelName, models;
        modelName = getModelName(this.constructor);
        conditions = {};
        switch (false) {
          case !foreignKey:
            conditions[foreignKey] = this.id;
            break;
          case !as:
            conditions["" + as + "_type"] = modelName;
            conditions["" + as + "_id"] = this.id;
            break;
          default:
            foreignKey = getForeignKey(modelName);
            conditions[foreignKey] = this.id;
        }
        collection = findCollection(collectionName);
        models = collection.where(conditions);
        return new collection.constructor(models, collectionOptions);
      };
    },
    belongsTo: function(associationName, _arg) {
      var modelName, polymorphic, _ref;
      _ref = _arg != null ? _arg : {}, modelName = _ref.modelName, polymorphic = _ref.polymorphic;
      return this.prototype[decapitalize(associationName)] = function() {
        var collectionName, foreignKey;
        switch (false) {
          case !polymorphic:
            collectionName = this.get("" + associationName + "_type");
            foreignKey = "" + associationName + "_id";
            break;
          case !modelName:
            collectionName = modelName;
            foreignKey = getForeignKey(associationName);
            break;
          default:
            collectionName = associationName;
            foreignKey = getForeignKey(associationName);
        }
        return findCollection(collectionName).get(this.get(foreignKey));
      };
    }
  });

  findCollection = function(name) {
    var collection, possibleName, possibleNames, _i, _len;
    possibleNames = [name, pluralize(name), decapitalize(pluralize(name))];
    for (_i = 0, _len = possibleNames.length; _i < _len; _i++) {
      possibleName = possibleNames[_i];
      if (collection = Backbone.Benefits.db[possibleName]) {
        return collection;
      }
    }
  };

  getModelName = function(model) {
    var _ref, _ref1, _ref2;
    return (_ref = (_ref1 = model.modelName) != null ? _ref1 : model.name) != null ? _ref : (_ref2 = model.toString().match(/function\s*(\w+)/)) != null ? _ref2[1] : void 0;
  };

  getForeignKey = function(string) {
    return underscore(singularize(string)) + "_id";
  };

  underscore = function(string) {
    return string.replace(/([a-z\d])([A-Z]+)/g, "$1_$2").replace(/[-\s]+/g, "_").toLowerCase();
  };

  capitalize = function(string) {
    return string.charAt(0).toUpperCase() + string.substring(1);
  };

  decapitalize = function(string) {
    return string.charAt(0).toLowerCase() + string.substring(1);
  };

  pluralize = function(string) {
    return string.replace(/([^s])$/, "$1s");
  };

  singularize = function(string) {
    return string.replace(/s$/, "");
  };

}).call(this);
