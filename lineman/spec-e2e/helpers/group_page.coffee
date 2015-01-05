module.exports = class GroupPage

  loadForInvitations: ->
    browser.get('http://localhost:8000/angular_support/setup_for_invite_people')

  invitePeopleLink: ->
    element(By.css('.cuke-group-invite-people'))

  invitePeopleField: ->
    element(By.css('.cuke-group-invite-people-field'))

  invitePerson: (fragment) ->
    @invitePeopleLink().click()
    element(By.model('fragment')).sendKeys(fragment)
    @firstInvitable().click()

  sendInvitations: ->
    element(By.css('.cuke-group-invitation-submit'))

  firstInvitable: ->
    element(By.css('.cuke-group-invitable-option')).first()

  addInvitation: ->

  members: ->
    []