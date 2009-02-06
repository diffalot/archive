    
    
  ## Archive.create('archive@user.email', 'password', 'ArchiveIdentifier', 'files_xml', 'metadata_xml')
  def self.create(archive_user, archive_password, archive_identifier, xml_files, xml_meta) 
    
    item = ArchiveItem.new(archive_identifier, xml_files, xml_meta)
    
    create_xml = Net::HTTP.get(URI.parse('http://www.archive.org/create.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
    
    create = XmlSimple.xml_in(create_xml)
    
    uri = URI.parse('ftp://' + create['url'].to_s)
    path = uri::path

    ftp = Net::FTP.new(uri.host)
    ftp.login(user = archive_user, archive_password)
    ftp.chdir(path)
    ftp.putbinaryfile('/test.jpg')
    ftp.close
      
    response = Net::HTTP.get(URI.parse('http://www.archive.org/checkin.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
    puts response
  end
end