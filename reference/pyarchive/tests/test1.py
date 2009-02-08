import pyarchive as pya
import pyarchive.submission as submission

submission = submission.ArchiveItem('sdfsdfaa-naughty', 
                                        pya.const.OPENSOURCE_AUDIO, 
                                        pya.const.AUDIO, 
                                        'Naughty')
# submission['runtime'] = '5:20'
submission['license'] = 'http://creativecommons.org/licenses/by-sa/2.0/'
submission[pya.const.CREATOR] = '_aa_'
submission[pya.const.NOTES] = 'More information available at http://www.anal0g.org/'

file1 = submission.addFile('sdflkknaughty.mp3',
                           pya.const.ORIGINAL,
                           pya.const.MP3_128K)

print submission.submit('archive@yergler.net', 'xxx')
