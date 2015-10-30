fs = require 'fs'
jsforce = require 'jsforce'
archiver = require 'archiver'

{SFDC_PASSWORD, SFDC_TOKEN, SFDC_LOGIN} = process.env
PACKAGE = 'dist/apex.zip'


###
Zip APEX Package
###
output = fs.createWriteStream(PACKAGE)
archive = archiver('zip')
archive.pipe(output)
archive.directory('pkg')
archive.finalize()


###
Deploy APEX Package
###
conn = new jsforce.Connection()
conn.login SFDC_LOGIN, "#{SFDC_PASSWORD}#{SFDC_TOKEN}", (err) ->

  zipStream = fs.createReadStream(PACKAGE)
  conn.metadata.deploy(zipStream).complete (err, result) ->
    console.log err if err?
