"""
pyarchive.cb_ftp

A wrapper for ftplib with basic callback facilities.

copyright 2004, Creative Commons, Nathan R. Yergler
"""

__id__ = "$Id: cb_ftp.py 432 2004-10-04 13:27:50Z nyergler $"
__version__ = "$Revision: 432 $"
__copyright__ = '(c) 2004, Creative Commons, Nathan R. Yergler'
__license__ = 'licensed under the GNU GPL2'

import ftplib

def noop(connection):
    pass

class FTP(ftplib.FTP):
    DEF_BLOCKSIZE=8192

    def storbinary(self, cmd, fp, blocksize=DEF_BLOCKSIZE, callback=noop):
        ''' Store a file in binary mode.'''
        if callback is None:
            callback = noop
            
        self.voidcmd('TYPE I')
        conn = self.transfercmd(cmd)
        while 1:
            buf = fp.read(blocksize)
            if not buf: break
            conn.send(buf)

            callback(bytes=blocksize)

        conn.close()
        return self.voidresp()

