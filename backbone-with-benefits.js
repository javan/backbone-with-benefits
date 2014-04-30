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
    hasMany: function(associationName, _arg) {
      var as, collectionName, conditions, foreignKey, modelName, source, through, _ref;
      _ref = _arg != null ? _arg : {}, foreignKey = _ref.foreignKey, as = _ref.as, through = _ref.through, conditions = _ref.conditions, modelName = _ref.modelName, collectionName = _ref.collectionName, source = _ref.source;
      return this.prototype[decapitalize(associationName)] = function(collectionOptions) {
        var collection, models, thisModelName, _ref1;
        if (collectionName == null) {
          collectionName = modelName != null ? modelName : associationName;
        }
        if (conditions == null) {
          conditions = {};
        }
        thisModelName = getModelName(this.constructor);
        collection = findCollection(collectionName);
        if (through != null) {
          if (source == null) {
            source = singularize(collectionName);
          }
          if (_.isEmpty(conditions)) {
            models = _(this[through]().toArray()).invoke(source);
          } else {
            models = _(this[through]().where(conditions)).invoke(source);
          }
          if (collection == null) {
            collection = (_ref1 = models[0]) != null ? _ref1.collection : void 0;
          }
        } else {
          switch (false) {
            case !foreignKey:
              conditions[foreignKey] = this.id;
              break;
            case !as:
              conditions["" + as + "_type"] = thisModelName;
              conditions["" + as + "_id"] = this.id;
              break;
            default:
              foreignKey = getForeignKey(thisModelName);
              conditions[foreignKey] = this.id;
          }
          models = collection.where(conditions);
        }
        return new collection.constructor(models, collectionOptions);
      };
    },
    belongsTo: function(associationName, _arg) {
      var collectionName, foreignKey, modelName, polymorphic, _ref;
      _ref = _arg != null ? _arg : {}, polymorphic = _ref.polymorphic, foreignKey = _ref.foreignKey, modelName = _ref.modelName, collectionName = _ref.collectionName;
      return this.prototype[decapitalize(associationName)] = function() {
        switch (false) {
          case !polymorphic:
            collectionName = this.get("" + associationName + "_type");
            foreignKey = "" + associationName + "_id";
            break;
          case !modelName:
            if (collectionName == null) {
              collectionName = modelName;
            }
            if (foreignKey == null) {
              foreignKey = getForeignKey(associationName);
            }
            break;
          default:
            if (collectionName == null) {
              collectionName = associationName;
            }
            if (foreignKey == null) {
              foreignKey = getForeignKey(collectionName);
            }
        }
        if ((collectionName != null) && (foreignKey != null)) {
          return findCollection(collectionName).get(this.get(foreignKey));
        }
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
