angular.module('loomioApp').factory 'InvitationEndpointsInterface', (BaseEndpointsInterface) ->
  class InvitationEndpointsInterface extends BaseEndpointsInterface
    endpoint: 'invitations'
