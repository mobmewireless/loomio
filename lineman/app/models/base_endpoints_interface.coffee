angular.module('loomioApp').factory 'BaseEndpointsInterface', (RestfulClient) ->
  class BaseEndpointsInterface
    endpoint: 'undefined'

    constructor: ->
      @restfulClient = new RestfulClient(@endpoint)

      @restfulClient.onSuccess = (response) =>
        response.data[@endpoint]

      @restfulClient.onFailure = (response) ->
        console.log('request failure!', response)
        throw response

    fetchByKey: (key) ->
      @restfulClient.getMember(key)

    fetch: (params) ->
      @restfulClient.getCollection(params)

    create: (params) ->
      @restfulClient.create(params)