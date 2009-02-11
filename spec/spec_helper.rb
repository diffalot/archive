require 'spec'

ARCHIVE_ORG_ROOT_DIR = File.join(File.dirname(__FILE__), '..') unless defined?(ARCHIVE_ORG_ROOT_DIR)
ARCHIVE_ORG_SPEC_DIR = File.join(ARCHIVE_ORG_ROOT_DIR, 'spec') unless defined?(ARCHIVE_ORG_SPEC_DIR)
ARCHIVE_ORG_LIB_DIR  = File.join(ARCHIVE_ORG_ROOT_DIR, 'lib')  unless defined?(ARCHIVE_ORG_LIB_DIR)
$: << ARCHIVE_ORG_LIB_DIR
require 'archive'

SAMPLES_DIR = ARCHIVE_ORG_ROOT_DIR+'/spec/sample' unless defined?(SAMPLES_DIR)
TEST_PAYLOADS_ROOT_DIR = "/tmp/payloads"

Spec::Runner.configure do |config|

end
