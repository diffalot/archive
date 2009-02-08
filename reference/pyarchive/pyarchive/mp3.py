# PyMM - Python MP3 Manager
# Copyright (C) 2000 Pierre Hjalm <pierre.hjalm@dis.uu.se>
#
# Modified by Alexander Kanavin <ak@sensi.org>
# Removed ID tags support and added VBR support
# Used http://home.swipnet.se/grd/mp3info/ for information
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

""" mp3.py
Reads information from an mp3 file.
This is a python port of code taken from the mpg123 input module of xmms.
"""
import struct


def header(buf):
    return struct.unpack(">I",buf)[0]

def head_check(head):
    if ((head & 0xffe00000L) != 0xffe00000L):
        return 0
    if (not ((head >> 17) & 3)):
        return 0
    if (((head >> 12) & 0xf) == 0xf):
        return 0
    if ( not ((head >> 12) & 0xf)):
        return 0
    if (((head >> 10) & 0x3) == 0x3):
        return 0
    if (((head >> 19) & 1) == 1 and ((head >> 17) & 3) == 3 and ((head >> 16) & 1) == 1):
        return 0
    if ((head & 0xffff0000L) == 0xfffe0000L):
        return 0
        
    return 1

def filesize(file):
    """ Returns the size of file sans any ID3 tag
    """
    f=open(file)
    f.seek(0,2)
    size=f.tell()
    try:
        f.seek(-128,2)
    except:
        f.close()
        return 0

    buf=f.read(3)
    f.close()
    
    if buf=="TAG":
        size=size-128

    if size<0:
        return 0
    else:
        return size
    
table=[[
    [0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448],
    [0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384],
    [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320]],
       
       [
    [0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256],
    [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160],
    [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160]]]

def decode_header(head):
    """ Decode the mp3 header and put the information in a frame structure
    """
    freqs=[44100, 48000, 32000, 22050, 24000, 16000, 11025, 12000, 8000]
    fr={}
    if head & (1 << 20):
        if head & (1 << 19):
            fr["lsf"]=0
        else:
            fr["lsf"]=1
        fr["mpeg25"] = 0
    else:
        fr["lsf"] = 1
        fr["mpeg25"] = 1

    fr["lay"] = 4 - ((head >> 17) & 3)
    if fr["mpeg25"]:
        fr["sampling_frequency"] = freqs[6 + ((head >> 10) & 0x3)]
    else:
        fr["sampling_frequency"] = freqs[((head >> 10) & 0x3) + (fr["lsf"] * 3)]

    fr["error_protection"] = ((head >> 16) & 0x1) ^ 0x1
    fr["bitrate_index"] = ((head >> 12) & 0xf)
    fr["bitrate"]=table[fr["lsf"]][fr["lay"]-1][fr["bitrate_index"]]
    fr["padding"]=((head>>9) & 0x1)
    fr["channel_mode"]=((head>>6) & 0x3)
    
    if fr["lay"]==1:
        fr["framesize"]=table[fr["lsf"]][0][fr["bitrate_index"]]*12000
        fr["framesize"]=fr["framesize"]/fr["sampling_frequency"]
        fr["framesize"]=((fr["framesize"]+fr["padding"])<<2)-4
    elif fr["lay"]==2:
        fr["framesize"]=table[fr["lsf"]][1][fr["bitrate_index"]]*144000
        fr["framesize"]=fr["framesize"]/fr["sampling_frequency"]
        fr["framesize"]=fr["framesize"]+fr["padding"]-1
    elif fr["lay"]==3:
        fr["framesize"]=table[fr["lsf"]][2][fr["bitrate_index"]]*144000
        fr["framesize"]=fr["framesize"]/fr["sampling_frequency"]<<fr["lsf"]
        fr["framesize"]=fr["framesize"]+fr["padding"]-4
        pass
    else:
        return 0
        
    return fr

def decode_vbr(buf):
    vbr = {}
    if buf[:4] != "Xing":
	return 0
    frames_flag = ord(buf[7]) & 1
    if not frames_flag:
	return 0
    vbr["frames"] = header(buf[8:])
    return vbr
    
def decode_synch_integer(buf):
    return (ord(buf[0])<<21)+(ord(buf[1])<<14)+(ord(buf[2])<<7)+ord(buf[3])

def detect_mp3(filename):
    """ Determines whether this is an mp3 file and if so reads information
    from it.
    """
    try:
        f=open(filename,"rb")
    except:
        return 0

    try:
        tmp=f.read(4)
    except:
        f.close()
        return 0
    if tmp[:3] == 'ID3':
	try:
	    tmp = f.read(6)    
            f.seek(decode_synch_integer(tmp[2:])+10)
 	    tmp=f.read(4)
 	except:
	    f.close()
	    return 0

    try:
        head=header(tmp)
    except:
        return 0
    
    while not head_check(head):
        # This is a real time waster, but an mp3 stream can start anywhere
        # in a file so we have to search the entire file which can take a
        # while for large non-mp3 files.
        try:
            buf=f.read(1024)
        except:
            f.close()
            return 0
        if buf=="":
            f.close()
            return 0
        for i in range(0,len(buf)-1):
            head=long(head)<<8;
            head=head|ord(buf[i])
            if head_check(head):
                f.seek(i+1-len(buf),1)
                break
    mhead=decode_header(head)

    if mhead:
	# Decode VBR header if there's any.
	pos = f.tell()
	mhead["vbr"] = 0
	if not mhead["lsf"]:
	    if mhead["channel_mode"] == 3:
		vbrpos = 17
	    else:
		vbrpos = 32
	else:
            if mhead["channel_mode"] == 3:  
                vbrpos = 9
            else:
                vbrpos = 17
 	
	try:
	    f.seek(vbrpos,1)
	    vbr = decode_vbr(f.read(12))
	    mhead["vbrframes"] = vbr["frames"]
	    if mhead["vbrframes"] >0:
	        mhead["vbr"] = 1
	except:
	   pass 

        # We found something which looks like a MPEG-header
        # We check the next frame too, to be sure
        if f.seek(pos+mhead["framesize"]):
            f.close()
            return 0
        try:
            tmp=f.read(4)
        except:
            f.close()
            return 0
        if len(tmp)!=4:
            f.close()
            return 0
        htmp=header(tmp)
        if not (head_check(htmp) and decode_header(htmp)):
            f.close()
            return 0
        
    f.close()

    # If we have found a valid mp3 add some more info the head data.
    if mhead:
        mhead["filesize"]=filesize(filename)
	if not mhead["vbr"]:
            if mhead["bitrate"] and mhead["filesize"]:
                mhead["time"]=int(float(mhead["filesize"])/(mhead["bitrate"]*1000)*8)
            else:
                mhead["time"]=0
	else:
	    if mhead["filesize"] and mhead["sampling_frequency"]:
	        medframesize = float(mhead["filesize"])/float(mhead["vbrframes"])
		if mhead["lsf"]:
		    coef = 12
		else:
		    coef = 144
		vbrrate = medframesize*mhead["sampling_frequency"]/(1000*coef)
		mhead["time"]=int(float(mhead["filesize"])/(vbrrate*1000)*8)
		mhead["vbrrate"] = int(vbrrate)
	    
        return mhead
    else:
        return 0

if __name__=="__main__":
    import sys
    mp3info=detect_mp3(sys.argv[1])
    if mp3info:
        print mp3info
    else:
        print "Not an mp3 file."
