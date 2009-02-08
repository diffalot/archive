"""
pyarchive.

copyright 2004, Creative Commons, Nathan R. Yergler
"""

__id__ = "$Id: const.py 846 2005-03-28 13:29:11Z nyergler $"
__version__ = "$Revision: 846 $"
__copyright__ = '(c) 2004, Creative Commons, Nathan R. Yergler'
__license__ = 'licensed under the GNU GPL2'

# source options
ORIGINAL = 'original'
DERIVITAVE = 'derivative'

# media types
AUDIO = 'audio'
MOVIE = VIDEO = 'movies'

# collection names
OPENSOURCE_AUDIO = 'opensource_audio'
OPENSOURCE_MOVIES = 'opensource_movies'
OPENSOURCE_MEDIA = 'opensource_media'

# meta keywords
VALID_META = {}

DATE = 'date'
PRODUCER = 'producer'
PROD_COMPANY = 'production_company'
DIRECTOR = 'director'
CONTACT = 'contact'
SPONSOR = 'sponsor'
DESC = 'description'
RUNTIME = 'runtime'
COLOR = 'color'
SOUND = 'sound'
SHOTLIST = 'shotlist'
SEGMENTS = 'segments'
CREDITS = 'credits'
COUNTRY = 'country'

CREATOR = 'creator'
TAPER = 'taper'
SOURCE = 'source'
NOTES = 'notes'

VALID_META[MOVIE] = [DATE, PRODUCER, PROD_COMPANY, DIRECTOR, CONTACT, SPONSOR,
                      DESC, RUNTIME, COLOR, SOUND, SHOTLIST, SEGMENTS, CREDITS,
                      COUNTRY]

VALID_META[AUDIO] = [CREATOR, DESC, TAPER, SOURCE, RUNTIME, DATE, NOTES]

# files keywords
FORMAT = 'format'

# RUNTIME is also for files metadata

# format names
WAVE = 'WAVE'
MP3_64K = '64Kbps MP3'
MP3_128K = '128Kbps MP3'
MP3_256K = '256Kbps MP3'
MP3_VBR = 'VBR MP3'
MP3_96K = '96Kbps MP3'
MP3_160K = '160Kbps MP3'
MP3_192K = '192Kbps MP3'

MP3 = {64: MP3_64K,
       128: MP3_128K,
       256: MP3_256K,
       'VBR': MP3_VBR,
       96: MP3_96K,
       160: MP3_160K,
       192: MP3_192K
       }

OGG_VORBIS = 'Ogg Vorbis'
SHORTEN = 'Shorten'
FLAC = 'Flac'
FLAC_24b = '24bit Flac'
M3U_64K = '64Kbps M3U'
M3U_VBR = 'VBR M3U'
MP3_64K_ZIP = '64Kbps MP3 ZIP'
VBR_ZIP = 'VBR ZIP'
SHORTEN_ZIP = 'Shorten ZIP'
FLAC_ZIP = 'Flac ZIP'
CHECKSUMS = 'Checksums'
MPEG2 = 'MPEG2'
MPEG1 = 'MPEG1'
MPEG4_64K = '64Kb MPEG4'
MPEG4_256K = '256Kb MPEG4'
MPEG4 = 'MPEG4'
QT_56K = '56Kb QuickTime'
QT_64K = '64Kb QuickTime'
QT_256K = '256Kb QuickTime'
QT = 'QuickTime'
DIVX = 'DivX'
IV50 = 'IV50'
WINDOWS_MEDIA = 'Windows Media'
CINEPACK = 'Cinepack'
ANIM_GIF = 'Animated GIF'
THUMBNAIL = 'Thumbnail'
JPEG = 'JPEG'
TIFF_SINGLE_ORIG = 'Single Page Original TIFF'
TIFF_SINGLE_PROC = 'Single Page Processed TIFF'
TIFF_MULTI_ORIG = 'Multi Page Original TIFF'
TIFF_MULTI_PROC = 'Multi Page Processed TIFF'
DJVU = 'DjVu'
TEXT = 'Text'
TEXT_PAGE = 'Single Book Page Text'
TEXT_TGZ = 'TGZiped Text Files'
BOOK_COVER = 'Book Cover'
DAT = 'DAT'
ARC = 'ARC'
META = 'Metadata'
FILES_META = 'Files Metadata'
ITEM_META = 'Item Metadata'
BOOK_META = 'Book Metadata'

VALID_FORMATS = (WAVE,
                 MP3_64K,
                 MP3_128K,
                 MP3_256K,
                 MP3_VBR,
                 MP3_96K,
                 MP3_160K,
                 MP3_192K,
                 OGG_VORBIS,
                 SHORTEN,
                 FLAC,
                 FLAC_24b,
                 M3U_64K,
                 M3U_VBR,
                 MP3_64K_ZIP,
                 VBR_ZIP,
                 SHORTEN_ZIP,
                 FLAC_ZIP,
                 CHECKSUMS,
                 MPEG2,
                 MPEG1,
                 MPEG4_64K,
                 MPEG4_256K,
                 MPEG4,
                 QT_56K,
                 QT_64K,
                 QT_256K,
                 QT,
                 DIVX,
                 IV50,
                 WINDOWS_MEDIA,
                 CINEPACK,
                 ANIM_GIF,
                 THUMBNAIL,
                 JPEG,
                 TIFF_SINGLE_ORIG,
                 TIFF_SINGLE_PROC,
                 TIFF_MULTI_ORIG,
                 TIFF_MULTI_PROC,
                 DJVU,
                 TEXT,
                 TEXT_PAGE,
                 TEXT_TGZ,
                 BOOK_COVER,
                 DAT,
                 ARC,
                 META,
                 FILES_META,
                 ITEM_META,
                 BOOK_META
                 )


FILE_FORMATS = {'audio':['WAVE',
'64Kbps MP3',
'128Kbps MP3',
'256Kbps MP3',
'VBR MP3',
'96Kbps MP3',
'160Kbps MP3',
'192Kbps MP3',
'MP3 (other)',
                         'Ogg Vorbis',
                         'Flac',
'24bit Flac',
'64Kbps M3U',
'VBR M3U',
'64Kbps MP3 ZIP',
                         'Shorten',
                         'Shorten ZIP',
                         'Flac ZIP',
                         'VBR ZIP',
'Other',
                        ],
                'video':['MPEG2',
                               'MPEG1',
'64Kb MPEG4',
'256Kb MPEG4',
'MPEG4',
'56Kb QuickTime',
'64Kb QuickTime',
'256Kb QuickTime',
                               'QuickTime',
                               'DivX',
                               'IV50',
                               'Windows Media',
                               'Cinepack',
                               'Animated GIF',
                               'Flash',
				'Other',
                              ],
                'text':['Text',
                        'HTML',
                        'Book Cover',
                        'Book Metadata',
			'Word document',
			'PDF',
			'RTF',
			'Other',
                       ],
                'image':['Thumbnail',
                         'JPEG',
                         'TIFF',
                         'BMP',
                         'EPS',
                         'GIF',
                         'PDF',
                         'PICT',
                         'PNG',
                         'PXR',
                         'RAW',
                         'Scitex CT',
                         'Targa',
			 'Other',
                         ],
'other':['Games',
         'HTML',
         'Software',
         'Keynote',
	 'Powerpoint (PPT)',
         'Other',
        ]
               }

