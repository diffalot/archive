module Archive
  module Metadata
    module FileMetadata
      def files_xml
        items.to_xml(:root => 'files')
      end
    end
  end
end
