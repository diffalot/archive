Module Archive

  class ArchiveItem

    include EasyClassMaker

    attributes :archive_identifier, :xml_files, :xml_meta

    class << self
      def new(archive_identifier, xml_files, xml_meta)
        ArchiveItem.new do |i|
          i.archive_identifier    = archive_identifier
          i.xml_files             = xml_files
          i.xml_meta              = xml_meta
        end
      end
    end
  end
end