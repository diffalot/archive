require File.dirname(__FILE__)+'/../spec_helper'

describe Archive::Payload do
  before(:each) do
  end

  describe "A well-behaved Payload" do
    before(:each) do
      @payload = Archive::InfochimpsPayload.new TEST_PAYLOADS_ROOT_DIR+"/complex",
        :identifier  => :sample_002,
        :title       => "Test File, please remove",
        :description => 'Yes We Can speech, used as a test upload.  Please delete me.',
        :mediatype   => 'data',
        :files       => 'sample_contents_file.txt'
    end

    it "should accept arbitrary metadata" do
      @payload.archive_org_metadata(:payload_metadata).should =~ %r{<collection>infochimps</collection>}
    end

    it "should create the metadata files on save" do
      @payload.save_metadata!
      #
      metadata_files = [:payload_metadata, :files_listing].map{|c| @payload.metadata_file_path(c) }.join(" ")
      puts `cat #{metadata_files}`
    end

    it "should accept files" do ; end

    it "should copy the file in" do ; end

    it "should have contents" do
      @payload.files.each{|pf| pf.contents.should be_a_kind_of(String) }
    end

    it "should instantiate from a directory" do
      # payload = Archive::Payload.new_from_dir '/tmp/payloads/complex',
      #   :runtime     => '2:30',
      #   :director    => 'Joe Producer'
      # p [payload, payload.base_path, payload.files, ]
      # payload.copy_and_add_files ARCHIVE_ORG_SPEC_DIR+'/sample/sample_contents_file.txt'
      # puts payload.archive_org_metadata(:payload_metadata)
    end

  end
end


# http://www.archive.org/services/contrib-submit.php?user_email=archiver@infochimps.org&server=items-uploads.archive.org&dir=sample_000
