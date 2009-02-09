require File.dirname(__FILE__)+'/../spec_helper'

describe Archive::Repository do
  def load_sample filename
    File.read(SAMPLES_DIR + "/#{filename}")
  end

  before(:each) do
    @repository = Archive::Repository.new
    @successful_response = Archive::ApiResponse.new(load_sample("xml_response_success.xml"))
    @error_response      = Archive::ApiResponse.new(load_sample("xml_response_error.xml"))
  end

  it "should return the URL on success" do
    @repository.stub!(:tickle_creation_notifier).and_return(@successful_response)
    @repository.create(@payload).should == 'http://www.archive.org/details/MyHomeMovie'
  end

  # it "should believe a successful response was successful" do
  #   Archive::Repository.send(:parse_response, @successful_response)
  # end

end
