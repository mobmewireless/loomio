angular.module('loomioApp').factory 'RecordStore', () ->
  class RecordStore
    constructor: (db) ->
      @db = db
      @collectionNames = []

    addEndpointInterface: (endpointsInterfaceClass) ->
      endpointsInterface = new endpointsInterfaceClass(@)
      @[endpointsInterface.endpoint] = endpointsInterface

    addRecordsInterface: (recordsInterfaceClass) ->
      recordsInterface = new recordsInterfaceClass(@)
      name = recordsInterface.model.plural
      @[name] = recordsInterface
      @collectionNames.push name

    import: (data) ->
      _.each @collectionNames, (name) =>
        if data[name]?
          _.each data[name], (record_data) =>
            @[name].initialize(record_data)
      data
