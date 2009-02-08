"""
pyarchive.submission

A Python library which provides an interface for uploading files to the
Internet Archive.

copyright 2004, Creative Commons, Nathan R. Yergler
"""

__id__ = "$Id: submission.py 844 2005-03-21 20:36:01Z nyergler $"
__version__ = "$Revision: 844 $"
__copyright__ = '(c) 2004, Creative Commons, Nathan R. Yergler'
__license__ = 'licensed under the GNU GPL2'

import cStringIO as StringIO
import cb_ftp
import urllib2
import xml.dom.minidom
import xml.sax.saxutils
import os.path
import string
import types
import codecs

from pyarchive.exceptions import MissingParameterException
from pyarchive.exceptions import SubmissionError
import pyarchive.utils
import pyarchive.const

# from cctag.metadata import metadata

class ArchiveItem:
    """
    <metadata>
      <collection>opensource_movies</collection>
      <mediatype>movies</mediatype>
      <title>My Home Movie</title>
      <runtime>2:30</runtime>
      <director>Joe Producer</director>
    </metadata>    
    """

    def __init__(self, identifier, collection, mediatype,
                 title, runtime=None, adder=None, license=None):
        self.files = []
        self.identifier = identifier
        self.collection = collection
        self.mediatype = mediatype
        self.title = title

        self.metadata = {}

        self.metadata['runtime'] = runtime
        self.metadata['adder'] = adder
        self.metadata['license'] = license

        if collection == pyarchive.const.OPENSOURCE_AUDIO:
            self.server = 'audio-uploads.archive.org'
        elif collection == pyarchive.const.OPENSOURCE_MOVIES:
            self.server = 'movies-uploads.archive.org'
        else:
            self.server = 'items-uploads.archive.org'
            
        self.archive_url = None

    def __setitem__(self, key, value):
        if key == 'subjects':
            subjects = [n.strip() for n in value.split(',')]
            self.metadata['subject'] = subjects
            
        else:
            self.metadata[key] = value

    def __getitem__(self, key):
        return self.metadata[key]
    
    def addFile(self, filename, source, format=None, claim=None):
        self.files.append(ArchiveFile(filename, source, format, claim))

        # set the running time to defaults
        self.files[-1].runtime = self.metadata['runtime']

        # return the added file object
        return self.files[-1]
    
    def metaxml(self, username=None):
        """Generates _meta.xml to use in submission;
        returns a file-like object."""

        meta_out = StringIO.StringIO()
        result = codecs.getwriter('UTF-8')(meta_out)

        result.write('<metadata>')

        # write the required keys
        result.write(u"""
        <title>%s</title>
        <collection>%s</collection>
        <mediatype>%s</mediatype>
        <upload_application appid="ccpublisher" version="1.0.6" />
        """ % (self.title, self.collection, self.mediatype) )

        if username is not None:
            result.write(u"<uploader>%s</uploader>\n" % username)
        
        # write any additional metadata
        for key in self.metadata:
            if self.metadata[key] is not None:
                value = self.metadata[key]

                # check if value is a list
                if type(value) in [types.ListType, types.TupleType]:
                    # this is a sequence
                    for n in value:
                        result.write(u'<%s>%s</%s>\n' % (
                                           key,
                                           xml.sax.saxutils.escape(n),
                                           key)
                                     )
                else:
                    result.write(u'<%s>%s</%s>\n' % (
                                           key,
                                           xml.sax.saxutils.escape(value),
                                           key) )

        result.write(u'</metadata>\n')

        result.seek(0)

        meta_out.seek(0)
        print meta_out.getvalue()
        meta_out.seek(0)
        
        return meta_out
        
    def filesxml(self):
        """Generates _files.xml to use in submission;
        returns a file-like object."""
        
        result = StringIO.StringIO()

        result.write('<files>\n')
        for archivefile in self.files:
            result.write(archivefile.fileNode())
        result.write('</files>\n')

        result.seek(0)
        return result

    def sanityCheck(self):
        """Perform sanity checks before submitting to archive.org"""
        # do some simple sanity checks
        if None in (self.identifier, self.collection, self.mediatype):
            raise MissingParameterException

        if len(self.files) < 1:
            raise MissingParameterException

        for archivefile in self.files:
            archivefile.sanityCheck()
        
        
    def submit(self, username, password, server=None, callback=None):
        """Submit the files to archive.org"""

        # set the server/adder (if necessary)
        if server is not None:
            self.server = server

        if self.metadata['adder'] is None:
            self.metadata['adder'] = username

        # make sure we're ready to submit
        self.sanityCheck()

        # reset the status
        callback.reset(steps=10)
        
        # connect to the FTP server
        callback.increment(status='connecting to archive.org...')

        ftp = cb_ftp.FTP(self.server)
        ftp.login(username, password)

        # create a new folder for the submission
        callback.increment(status='creating folder for uploads...')

        ftp.mkd(self.identifier)
        ftp.cwd(self.identifier)

        # upload the XML files
        callback.increment(status='uploading metadata...')

        ftp.storlines("STOR %s_meta.xml" % self.identifier,
                      self.metaxml(username))
        ftp.storlines("STOR %s_files.xml" % self.identifier,
                      self.filesxml())

        # upload each file
        callback.increment(status='uploading files...')

        for archivefile in self.files:
            # determine the local path name and switch directories
            localpath, fname = os.path.split(archivefile.filename)
            os.chdir(localpath)

            # reset the gauge for this file
            callback.reset(filename=fname)
            
            ftp.storbinary("STOR %s" % archivefile.archiveFilename(),
                           file(fname, 'rb'), callback=callback)

        ftp.quit()
        
        # call the import url, check the return result
        callback.reset(steps=3)
        callback.increment(status='finishing submission...')
        importurl = "http://www.archive.org/services/contrib-submit.php?" \
                    "user_email=%s&server=%s&dir=%s" % (
                    username, self.server, self.identifier)
        response = urllib2.urlopen(importurl)
                    
        callback.increment(status='checking response...')
        response_dom = xml.dom.minidom.parse(response)
        result_type = response_dom.getElementsByTagName("result")[0].getAttribute("type")

        if result_type == 'success':
           # extract the URL element and store it
           self.archive_url = response_dom.getElementsByTagName("url")[0].childNodes[0].nodeValue
        else:
           # an error occured; raise an exception
           raise SubmissionError("%s: %s" % (
                                    response_dom.getElementsByTagName("result")[0].getAttribute("code"),
                                    response_dom.getElementsByTagName("message")[0].childNodes[0].nodeValue
                                ))
        callback.finish()
           
        return self.archive_url
        
class ArchiveFile:
    def __init__(self, filename, source = None, format = None, claim = None):
        # make sure the file exists
        if not(os.path.exists(filename)):
            # can not find the file; raise an exception
            raise IOError
        
        # set object properties from suppplied parameters
        self.filename = filename
        self.runtime = None
        self.source = source
        self.format = format
        self.__claim = claim

        if self.format is None:
            self.__detectFormat()

    def __detectFormat(self):
        info = pyarchive.utils.getFileInfo(os.path.split(self.filename)[1],
                                           self.filename)

        bitrate = info[2]
        if bitrate is not None:
            if bitrate[1]:
                self.format = pyarchive.const.MP3['VBR']
            else:
                self.format = pyarchive.const.MP3[bitrate[0]]
                
    def fileNode(self):
        """Generates the XML to represent this file in files.xml."""
        result = '<file name="%s" source="%s">\n' % (
            self.archiveFilename(), self.source)
        
        if self.runtime is not None:
            result = result + '<runtime>%s</runtime>\n' % self.runtime

        # removing metadata dependency for stand-alone-ish-ness
        #if self.__claim is None:
        #    try:
        #        self.__claim = metadata(self.filename).getClaim()
        #    except NotImplementedError, e:
        #        pass
            
        if self.__claim:
            result = result + '<license>%s</license>\n' % \
                     xml.sax.saxutils.escape(self.__claim)
            
        result = result + '<format>%s</format>\n</file>\n' % \
                 xml.sax.saxutils.escape(self.format)

        return result
    
    def sanityCheck(self):
        """Perform simple sanity checks before uploading."""
        # make sure the file exists
        if not(os.path.exists(self.filename)):
            # can not find the file; raise an exception
            raise IOError

        # ensure necessary parameters have been supplied
        if None in (self.filename, self.source, self.format):
            raise MissingParameterException

    def archiveFilename(self):
        localpath, fname = os.path.split(self.filename)
        
        fname = fname.replace(' ', '_')
        chars = [n for n in fname if n in
                 (string.ascii_letters + string.digits + '._')]
        
        result = "".join(chars)
        if result[0] == '.':
            # the first character is a dot,
            # indicating there's nothing before the extension.
            result = '%s%s' % (hash(result), result)

        return result
    
    
        
        
        

