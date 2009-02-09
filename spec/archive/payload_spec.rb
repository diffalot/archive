require File.dirname(__FILE__)+'/../spec_helper'

TEST_PAYLOADS_ROOT_DIR = "/tmp/payloads"

describe Archive::Payload do
  before(:each) do
  end

  describe "A well-behaved Payload" do
    before(:each) do
      @payload = Archive::Payload.new TEST_PAYLOADS_ROOT_DIR+"/complex", :title => 'My Home Movie',
        :description => "Our trip to mars",
        :collection  => 'opensource_movies',
        :description => 'Our Vacation to the moon',
        :runtime     => '2:30',
        :director    => 'Joe Producer',
        :files       => 'example_file.txt'
    end

    it "should accept arbitrary metadata" do
      @payload.archive_org_metadata(:payload_metadata).should =~ %r{<runtime>2:30</runtime>}
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
      payload = Archive::Payload.new_from_dir '/tmp/payloads/complex',
        :runtime     => '2:30',
        :director    => 'Joe Producer'
      p [payload, payload.base_path, payload.files,

      ]
      puts payload.archive_org_metadata(:payload_metadata)
    end

  end
end

