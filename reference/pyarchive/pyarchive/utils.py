# Copyright (c) 2001-2003 Alexander Kanavin. All rights reserved.
# licensed under the GNU GPL 2
#
# 2004-10-8 NRY Imported from PySoulSeek package

"""
This module contains utility fuctions.
"""

import string
import os.path
import os,dircache
import mp3

version = "1.2.5"

def getServerList(url):
        """ Parse server text file from http://www.slsk.org and 
        return a list of servers """
        import urllib,string
        try:
            f = urllib.urlopen(url)
            list = [string.strip(i) for i in f.readlines()]
        except:
            return []
        try:
            list = list[list.index("--servers")+1:]
        except:
            return []
        list = [string.split(i,":",2) for i in list]
        try:
            return [[i[0],i[2]]  for i in list]
        except:
            return []

def rescandirs(shared, sharedmtimes, sharedfiles, sharedfilesstreams, yieldfunction):
        newmtimes = getDirsMtimes(shared,yieldfunction)
        newsharedfiles = getFilesList(newmtimes, sharedmtimes, sharedfiles,yieldfunction)
        newsharedfilesstreams = getFilesStreams(newmtimes, sharedmtimes, sharedfilesstreams, newsharedfiles,yieldfunction)
        newwordindex, newfileindex = getFilesIndex(newmtimes, sharedmtimes, shared, newsharedfiles,yieldfunction)
        return newsharedfiles,newsharedfilesstreams,newwordindex,newfileindex, newmtimes
    

def getDirsMtimes(dirs, yieldcall = None):
    list = {}
    for i in dirs:
	i = i.replace("//","/")
	try:
	    contents = dircache.listdir(i)
	    mtime = os.path.getmtime(i)
	except OSError, errtuple:
	    print errtuple
	    continue
	list[i] = mtime
        for f in contents:
	    pathname = os.path.join(i, f)
            try:
                isdir = os.path.isdir(pathname)
		mtime = os.path.getmtime(pathname)
            except OSError, errtuple:
                print errtuple
		continue
	    else:
		if isdir:
		    list[pathname] = mtime
		    dircontents = getDirsMtimes([pathname])
		    for k in dircontents:
			list[k] = dircontents[k]
		if yieldcall is not None:
		    yieldcall()
    return list


def getFilesList(mtimes, oldmtimes, oldlist, yieldcall = None):
    """ Get a list of files with their filelength and 
    (if mp3) bitrate and track length in seconds """
    list = {}
    for i in mtimes:
	if oldmtimes.has_key(i):
	  if mtimes[i] == oldmtimes[i]:
	    list[i] = oldlist[i]
	    continue
	list[i] = []
	try:
	    contents = dircache.listdir(i)
	except OSError, errtuple:
	    print errtuple
	    continue
	for f in contents:
	    pathname = os.path.join(i, f)
	    try:
	        isfile = os.path.isfile(pathname)
	    except OSError, errtuple:
	        print errtuple
	        continue
	    else:
		if isfile:
                    # It's a file, check if it is mp3
	            list[i].append(getFileInfo(f,pathname))
	    if yieldcall is not None:
                yieldcall()
    return list

def getFileInfo(name, pathname):
    size = os.path.getsize(pathname)   
    if name[-4:] == ".mp3" or name[-4:] == ".MP3":
	mp3info=mp3.detect_mp3(pathname)
        if mp3info:
            if mp3info["vbr"]:
                bitrateinfo = (mp3info["vbrrate"],1)
            else:
                bitrateinfo = (mp3info["bitrate"],0)
            fileinfo = (name,size,bitrateinfo,mp3info["time"])
        else:
            fileinfo = (name,size,None,None)
    elif name[-4:] == ".ogg" or name[-4:] == ".OGG":
	try:
	    import ogg.vorbis
	    vf = ogg.vorbis.VorbisFile(pathname)
	    time = int(vf.time_total(0))
	    bitrate = vf.bitrate(0)/1000
	    fileinfo = (name,size, (bitrate,0), time)
	except:
	    fileinfo = (name,size,None,None)
    else:
	fileinfo = (name,size,None,None)
    return fileinfo


def getFilesStreams(mtimes, oldmtimes, oldstreams, sharedfiles, yieldcall = None):
    streams = {}
    for i in mtimes.keys():
	if oldmtimes.has_key(i):
	  if mtimes[i] == oldmtimes[i]:
	    streams[i] = oldstreams[i]
	    continue
	streams[i] = getDirStream(sharedfiles[i])
        if yieldcall is not None:
            yieldcall()
    return streams

def getDirStream(dir):
    from slskmessages import SlskMessage
    msg = SlskMessage()
    stream = msg.packObject(len(dir))
    for i in dir:
	stream = stream + getByteStream(i)
    return stream
	
def getByteStream(fileinfo):
    from slskmessages import SlskMessage
    self = SlskMessage()
    stream = chr(1) + self.packObject(fileinfo[0]) + self.packObject(fileinfo[1]) + self.packObject(0)
    if fileinfo[2] is not None:
        stream = stream + self.packObject('mp3') + self.packObject(3)
        stream = stream + self.packObject(0)+ self.packObject(fileinfo[2][0])+self.packObject(1)+ self.packObject(fileinfo[3])+self.packObject(2)+self.packObject(fileinfo[2][1])
    else:
        stream = stream + self.packObject('') + self.packObject(0)
    return stream


def getFilesIndex(mtimes, oldmtimes, shareddirs,sharedfiles, yieldcall = None):
    wordindex = {}
    fileindex = {}
    index = 0

    for i in mtimes.keys():
	for j in sharedfiles[i]:
	    indexes = getIndexWords(i,j[0],shareddirs)
	    for k in indexes:
		wordindex.setdefault(k,[]).append(index)
	    fileindex[str(index)] = (os.path.join(i,j[0]),)+j[1:]
	    index += 1
	if yieldcall is not None:
	    yieldcall()
    return wordindex, fileindex

def getIndexWords(dir,file,shareddirs):
    import os.path,string
    for i in shareddirs:
	if os.path.commonprefix([dir,i]) == i:
	    dir = dir[len(i):]
    words = string.split(string.lower(string.translate(dir+' '+file, string.maketrans(string.punctuation,string.join([' ' for i in string.punctuation],'')))))
    # remove duplicates
    d = {}
    for x in words:
	d[x] = x
    return d.values()
     
