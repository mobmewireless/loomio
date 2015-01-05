angular.module('loomioApp').controller 'InvitationsModalController', ($scope, $modalInstance, group, Records) ->
  $scope.group = group
  $scope.fragment = ''
  $scope.invitations = []

  $scope.hasInvitations = ->
    $scope.invitations.length > 0

  $scope.getInvitables = (fragment) ->
    Records.invitables.fetchByNameFragment(fragment, $scope.group.id).then $scope.handleInvitables

  $scope.handleInvitables = (invitables) ->
    if angular.element('#invitable-email').hasClass('ng-valid-email')
      invitables.concat [{ name: $scope.fragment, type: 'Email', email: $scope.fragment }]
    invitables

  $scope.addInvitation = (invitation) ->
    $scope.fragment = ''
    $scope.invitations.push invitation

  $scope.submit = ->
    $scope.isDisabled = true
    Records.invitations.create(invitationsParams()).then($scope.saveSuccess, $scope.saveError)

  invitationsParams = ->
    invitations: $scope.invitations
    group_id: $scope.group.id
    message: $scope.message

  $scope.cancel = ($event) ->
    $event.preventDefault()
    $modalInstance.dismiss('cancel')

  $scope.saveSuccess = () ->
    $scope.isDisabled = false
    $scope.invitations = []
    $modalInstance.close()

  $scope.saveError = (error) ->
    $scope.isDisabled = false
    $scope.errorMessages = error.error_messages

