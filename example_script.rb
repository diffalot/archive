#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/spec/dirs.rb'

title = 'Archive Gem Test' + Time.now.to_s
identifier = title.gsub(' ', '')

repository = Archive::Repository.new
payload = Archive::InfochimpsPayload.new TEST_PAYLOADS_ROOT_DIR+'/'+identifier,
    :identifier  => identifier,
    :title       => title,
    :description => 'Yes We Can speech, used as a test upload.  Please delete me.',
    :mediatype   => 'Text'

payload.copy_and_add_files ARCHIVE_ORG_SPEC_DIR+'/sample/sample_contents_file.txt'
payload.save_metadata!
repository.send(payload)
puts repository.notify_of_creation(payload)
