angular.module('loomioApp').factory 'InvitableEndpointsInterface', (BaseEndpointsInterface) ->
  class InvitableEndpointsInterface extends BaseEndpointsInterface
    endpoint: 'invitables'

    fetchByNameFragment: (fragment, groupId, success, failure) ->
      @fetch({q: fragment, group_id: groupId}, success, failure)
