angular.module('loomioApp').factory 'AttachmentRecordsInterface', ($upload, BaseRecordsInterface, AttachmentModel) ->
  class AttachmentRecordsInterface extends BaseRecordsInterface
    model:             AttachmentModel

    upload: (file, progress, success, failure) ->
      @getCredentials().then (credentials) =>
        params = uploadParameters(credentials, file)
        newAttachment = @recordStore.attachments.initialize attachmentParams(credentials, file)

        $upload.upload(params)
               .progress(progress)
               .error(failure)
               .abort(failure)
               .success (response) ->
                  newAttachment.save
                  success(response)

    abortUpload: ->
      $upload.abort()

    getCredentials: ->
      @restfulClient.get('credentials')

    attachmentParams = (credentials, file) ->
      filename: file.name
      filesize: file.size
      location: uploadKey(credentials, file)

    uploadParameters = (credentials, file) ->
      url:    credentials.url
      method: 'POST'
      file:   file
      data:
        utf8:           '✓',
        acl:            credentials.acl,
        policy:         credentials.policy,
        signature:      credentials.signature,
        AWSAccessKeyId: credentials.accessKey,
        key:            uploadKey(credentials, file),
        "Content-Type": file.type or 'application/octet-stream'

    uploadKey = (credentials, file) ->
      credentials.key.replace('${filename}', file.name)
