"""
pyarchive.identifier

A Python library which provides an interface for manipulating identifiers
used by the Internet Archive (archive.org).

copyright 2004, Creative Commons, Nathan R. Yergler
"""

__id__ = "$Id: identifier.py 703 2004-12-27 14:45:41Z nyergler $"
__version__ = "$Revision: 703 $"
__copyright__ = '(c) 2004, Creative Commons, Nathan R. Yergler'
__license__ = 'licensed under the GNU GPL2'

import urllib2
import xml.dom.minidom
import string

import exceptions

def available(identifier):
    """Checks availability for a given identifier; returns True if the
    identifier is available, False if already in use.  Note that this does
    *not* reserve the identifier, so race conditions may exist."""

    # concatenate the service URL
    checkurl = "http://www.archive.org/services/check_identifier.php?" \
               "identifier=%s" % identifier

    # make request
    response = urllib2.urlopen(checkurl)
    response_dom = xml.dom.minidom.parse(response)

    # parse the response DOM
    result = response_dom.getElementsByTagName("result")[0]
    result_type = result.getAttribute("type")
    result_code = result.getAttribute("code")

    if result_type == 'error':
        raise exceptions.MissingParameterException()
    
    if result_type == 'success' and result_code == 'available':
        return True

    return False

def munge(identifier):
    """Takes a string identifier and returns it, appropriatly munged
    (ie, no spaces, slashes, etc); useful for converting a title to an
    identifier."""

    letters = [n for n in identifier if
               n in string.letters or
               n in string.digits]

    return "".join(letters)

def verify_url(collection, identifier, mediatype):
    """Takes an archive.org identifier and returns the verification URL."""

    return "http://www.archive.org/%s/%s-details-db.php?"\
           "collection=%s&collectionid=%s" % (mediatype, mediatype,
                                              collection, identifier)

