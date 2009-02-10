# source options
ORIGINAL          = 'original'
DERIVATIVE        = 'derivative'

# media types
AUDIO             = 'audio'
MOVIE     = VIDEO = 'movies'

# collection names
OPENSOURCE_AUDIO  = 'opensource_audio'
OPENSOURCE_MOVIES = 'opensource_movies'
OPENSOURCE_MEDIA  = 'opensource_media'

# meta keywords
VALID_META        = [
  :description,
  :creator,
  :date,
  :source,
  :notes,

  :producer,
  :production_company,
  :director,
  :contact,
  :sponsor,
  :runtime,
  :color,
  :sound,
  :shotlist,
  :segments,
  :credits,
  :country,

  :taper,
]

# format names
WAVE     = 'WAVE'
MP3_64K  = '64Kbps MP3'
MP3_128K = '128Kbps MP3'
MP3_256K = '256Kbps MP3'
MP3_VBR  = 'VBR MP3'
MP3_96K  = '96Kbps MP3'
MP3_160K = '160Kbps MP3'
MP3_192K = '192Kbps MP3'

MP3 = {
  64       => MP3_64K,
  128      => MP3_128K,
  256      => MP3_256K,
  'VBR'    => MP3_VBR,
  96       => MP3_96K,
  160      => MP3_160K,
  192      => MP3_192K
}

FORMAT_NAMES = {
  :ogg_vorbis       => 'Ogg Vorbis',
  :shorten          => 'Shorten',
  :flac             => 'Flac',
  :flac_24b         => '24bit Flac',
  :m3u_64k          => '64Kbps M3U',
  :m3u_vbr          => 'VBR M3U',
  :mp3_64k_zip      => '64Kbps MP3 ZIP',
  :vbr_zip          => 'VBR ZIP',
  :shorten_zip      => 'Shorten ZIP',
  :flac_zip         => 'Flac ZIP',
  :checksums        => 'Checksums',
  :mpeg2            => 'MPEG2',
  :mpeg1            => 'MPEG1',
  :mpeg4_64k        => '64Kb MPEG4',
  :mpeg4_256k       => '256Kb MPEG4',
  :mpeg4            => 'MPEG4',
  :qt_56k           => '56Kb QuickTime',
  :qt_64k           => '64Kb QuickTime',
  :qt_256k          => '256Kb QuickTime',
  :qt               => 'QuickTime',
  :divx             => 'DivX',
  :iv50             => 'IV50',
  :windows_media    => 'Windows Media',
  :cinepack         => 'Cinepack',
  :anim_gif         => 'Animated GIF',
  :thumbnail        => 'Thumbnail',
  :jpeg             => 'JPEG',
  :tiff_single_orig => 'Single Page Original TIFF',
  :tiff_single_proc => 'Single Page Processed TIFF',
  :tiff_multi_orig  => 'Multi Page Original TIFF',
  :tiff_multi_proc  => 'Multi Page Processed TIFF',
  :djvu             => 'DjVu',
  :text             => 'Text',
  :text_page        => 'Single Book Page Text',
  :text_tgz         => 'TGZiped Text Files',
  :book_cover       => 'Book Cover',
  :dat              => 'DAT',
  :arc              => 'ARC',
  :meta             => 'Metadata',
  :files_meta       => 'Files Metadata',
  :item_meta        => 'Item Metadata',
  :book_meta        => 'Book Metadata',
}

FILE_FORMATS = {
  :audio => [
    'WAVE',
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
  :video => ['MPEG2',
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
  :text => ['Text',
    'HTML',
    'Book Cover',
    'Book Metadata',
    'Word document',
    'PDF',
    'RTF',
    'Other',
  ],
  :image => ['Thumbnail',
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
  :other => [
    'Games',
    'HTML',
    'Software',
    'Keynote',
    'Powerpoint (PPT)',
    'Other',
  ]
}


# allowed file format strings
File_formats = ["128Kbps MP3","128kbps M3U","160Kbps MP3","192Kbps MP3","24bit Flac","256Kb MPEG4","256Kb QuickTime","256Kbps MP3","320Kbps MP3","3GP","56Kb QuickTime","64Kb MPEG4","64Kb QuickTime","64Kbps M3U","64Kbps MP3","64Kbps MP3 ZIP","96Kbps MP3","AIFF","ARC","Abbyy GZ","Abbyy ZIP","Animated GIF","Article Metadata XML","Book Cover","Book Cover","Book Cover Image","Checksums","Cinepack","Collection Header","DAT","DV Video","DivX","DjVu","DjVuTXT","Djvu XML","Flac","Flac FingerPrint","Flash Video","Flippy ZIP","Grayscale LuraTech PDF","HTML","HiRes MPEG4","IV50","Image Container PDF","Item Image","JPEG","MPEG1","MPEG2","MPEG4","Metadata","Microfilm Original TIFF ZIP","Motion JPEG","Multi Page Original TIFF","Multi Page Processed TIFF","Ogg Theora","Ogg Vorbis","PDF","QuickTime","RAR","Real Media","Scribe Scandata ZIP","Shockwave Flash","Shorten","Single Book Page Text","Single Page FIXME JPEG Tar","Single Page FIXME JPEG ZIP","Single Page Library JP2 Tar","Single Page Library JP2 ZIP","Single Page Library TIFF ZIP","Single Page Original CR2 Tar","Single Page Original JP2 Tar","Single Page Original JP2 ZIP","Single Page Original JPEG","Single Page Original JPEG Tar","Single Page Original JPEG ZIP","Single Page Original TIFF","Single Page Original TIFF ZIP","Single Page Processed JP2 Tar","Single Page Processed JP2 ZIP","Single Page Processed JPEG","Single Page Processed JPEG Tar","Single Page Processed JPEG ZIP","Single Page Processed TIFF","Single Page Processed TIFF ZIP","Single Page Processed TIFF ZIP","Single Page Pure JP2 Tar","Single Page Pure JP2 ZIP","Single Page Raw JP2 Tar","Single Page Raw JP2 ZIP","Single Page Raw JPEG Tar","Single Page Raw JPEG ZIP","Single Page Watermark JP2 Tar","Single Page Watermark JP2 ZIP","Single Page Zipped PDF","Standard LuraTech PDF","TAR","TGZiped Text Files","Text","Thumbnail","VBR M3U","VBR MP3","VBR ZIP","WAVE","Windows Media","Windows Media Audio","ZIP","h.264 MPEG4"]
