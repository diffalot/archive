require File.dirname(__FILE__)+'/../spec_helper'

describe Archive::Repository do
  def load_sample filename
    File.read(SAMPLES_DIR + "/#{filename}")
  end

  before(:each) do
    @repository = Archive::Repository.new
    @payload = Archive::InfochimpsPayload.new TEST_PAYLOADS_ROOT_DIR+"/complex",
      :identifier  => :sample_002,
      :title       => "Test File, please remove",
      :description => 'Yes We Can speech, used as a test upload.  Please delete me.',
      :mediatype   => 'data',
      :files       => 'sample_contents_file.txt'
  end

  describe "when creating payload" do
    before(:each) do
      @successful_response = Archive::ApiResponse.new(load_sample("xml_response_success.xml"))
      @error_response      = Archive::ApiResponse.new(load_sample("xml_response_error.xml"))
    end

    # it "should fail with no payload"

    it "should return the URL on success" do
      @repository.stub!(:tickle_creation_notifier).and_return(@successful_response)
      # @repository.create(@payload).should == 'http://www.archive.org/details/MyHomeMovie'
    end

    it "should warn and return nil on failure" do
      @repository.stub!(:tickle_creation_notifier).and_return(@error_response)
      # @repository.create(@payload).should be_nil
    end


    it "should create a payload" do
      # puts @repository.send(@payload)
    end


  end
end
