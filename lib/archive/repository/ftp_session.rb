module Archive
  module Session

    class FtpSession

    # def upload item
    # (self, username, password, server=None, callback=None):
    #     """Submit the files to archive.org"""
    #
    #     # set the server/adder (if necessary)
    #     if server is not None:
    #         self.server = server
    #
    #     if self.metadata['adder'] is None:
    #         self.metadata['adder'] = username
    #
    #     # make sure we're ready to submit
    #     self.sanityCheck()
    #
    #     # reset the status
    #     callback.reset(steps=10)
    #
    #     # connect to the FTP server
    #     callback.increment(status='connecting to archive.org...')
    #
    #     ftp = cb_ftp.FTP(self.server)
    #     ftp.login(username, password)
    #
    #     # create a new folder for the submission
    #     callback.increment(status='creating folder for uploads...')
    #
    #     ftp.mkd(self.identifier)
    #     ftp.cwd(self.identifier)
    #
    #     # upload the XML files
    #     callback.increment(status='uploading metadata...')
    #
    #     ftp.storlines("STOR %s_meta.xml" % self.identifier,
    #                   self.metaxml(username))
    #     ftp.storlines("STOR %s_files.xml" % self.identifier,
    #                   self.filesxml())
    #
    #     # upload each file
    #     callback.increment(status='uploading files...')
    #
    #     for archivefile in self.files:
    #         # determine the local path name and switch directories
    #         localpath, fname = os.path.split(archivefile.filename)
    #         os.chdir(localpath)
    #
    #         # reset the gauge for this file
    #         callback.reset(filename=fname)
    #
    #         ftp.storbinary("STOR %s" % archivefile.archiveFilename(),
    #                        file(fname, 'rb'), callback=callback)
    #
    #     ftp.quit()
    #
    #     # call the import url, check the return result
    #     callback.reset(steps=3)
    #     callback.increment(status='finishing submission...')
    #     importurl = "http://www.archive.org/services/contrib-submit.php?" \
    #                 "user_email=%s&server=%s&dir=%s" % (
    #                 username, self.server, self.identifier)
    #     response = urllib2.urlopen(importurl)
    #
    #     callback.increment(status='checking response...')
    #     response_dom = xml.dom.minidom.parse(response)
    #     result_type = response_dom.getElementsByTagName("result")[0].getAttribute("type")
    #
    #     if result_type == 'success':
    #        # extract the URL element and store it
    #        self.archive_url = response_dom.getElementsByTagName("url")[0].childNodes[0].nodeValue
    #     else:
    #        # an error occured; raise an exception
    #        raise SubmissionError("%s: %s" % (
    #                                 response_dom.getElementsByTagName("result")[0].getAttribute("code"),
    #                                 response_dom.getElementsByTagName("message")[0].childNodes[0].nodeValue
    #                             ))
    #     callback.finish()
    #
    #     return self.archive_url

      # class FTP(ftplib.FTP):
      #     DEF_BLOCKSIZE=8192
      #
      #     def storbinary(self, cmd, fp, blocksize=DEF_BLOCKSIZE, callback=noop):
      #         ''' Store a file in binary mode.'''
      #         if callback is None:
      #             callback = noop
      #
      #         self.voidcmd('TYPE I')
      #         conn = self.transfercmd(cmd)
      #         while 1:
      #             buf = fp.read(blocksize)
      #             if not buf: break
      #             conn.send(buf)
      #
      #             callback(bytes=blocksize)
      #
      #         conn.close()
      #         return self.voidresp()

    end
  end
end


    # create_xml = Net::HTTP.get(URI.parse(ftp_uri))
    #
    # create = XmlSimple.xml_in(create_xml)
    #
    # uri = URI.parse('ftp://' + create['url'].to_s)
    # path = uri::path
    #
    # ftp = Net::FTP.new(uri.host)
    # ftp.login(user = archive_user, archive_password)
    # ftp.chdir(path)
    # ftp.putbinaryfile('/test.jpg')
    # ftp.close
    #
    # response = Net::HTTP.get(URI.parse('http://www.archive.org/checkin.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
