describe 'Group Page', ->

  GroupPage = require './helpers/group_page.coffee'
  page = new GroupPage

  it 'invite people', ->
    page.loadForInvitations()
    expect(page.invitePeopleLink().isPresent()).toBe(true)
    page.invitePerson('max')
    expect(page.members()).toContain('Max Von Sydow')
