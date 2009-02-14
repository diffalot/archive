module Archive
  class Ftp
    #
    # --connect-timeout <seconds>
    #
    #   Maximum time in seconds that you allow the connection to the server to
    #   take.  This only limits the connection phase, once curl has connected
    #   this option is of no more use. See also the -m/--max-time option.  If
    #   this option is used several times, the last one will be used.
    #
    # --ftp-pasv
    #
    #   (FTP) Use PASV when transferring. PASV is the internal default behavior,
    #   but using this option can be used to override a previous --ftp-port
    #   option. (Added in 7.11.0)
    #
    #   If this option is used several times, the following occurrences make no
    #   difference.
    #
    # --limit-rate <speed>
    #
    #   Specify the maximum transfer rate you want curl to use. This feature is
    #   useful if you have a limited pipe and you'd like your transfer not use
    #   your entire bandwidth.
    #
    #   The given speed is measured in bytes/second, unless a suffix is
    #   appended.  Appending 'k' or 'K' will count the number as kilobytes, 'm'
    #   or M' makes it megabytes while 'g' or 'G' makes it gigabytes. Examples:
    #   200K, 3m and 1G.
    #
    #   The given rate is the average speed, counted during the entire
    #   transfer. It means that curl might use higher transfer speeds in short
    #   bursts, but over time it uses no more than the given rate.
    #
    #   If you are also using the -Y/--speed-limit option, that option will take
    #   precedence and might cripple the rate-limiting slightly, to help keeping
    #   the speed-limit logic working.
    #
    #   If this option is used several times, the last one will be used.
    #
    # -m/--max-time <seconds>
    #
    #   Maximum time in seconds that you allow the whole operation to take.
    #   This is useful for preventing your batch jobs from hanging for hours due
    #   to slow networks or links going down.  See also the --connect-timeout
    #   option.
    #
    #   If this option is used several times, the last one will be used.
    #
    # -n/--netrc
    #
    #   Makes curl scan the .netrc file in the user's home directory for login
    #   name and password. This is typically used for ftp on unix. If used with
    #   http, curl will enable user authentication. See ftp(1) for details on
    #   the file format.  Curl will not complain if that file hasn't the right
    #   permissions (it should not be world nor group readable). The environment
    #   variable "HOME" is used to find the home directory.
    #
    #   A quick and very simple example of how to setup a .netrc to allow curl
    #   to ftp to the machine host.domain.com with user name 'myself' and
    #   password 'secret' should look similar to:
    #
    #   machine host.domain.com login myself password secret
    #
    #   If this option is used twice, the second will again disable netrc usage.
    #
    # --netrc-optional
    #
    #   Very similar to --netrc, but this option makes the .netrc usage optional
    #   and not mandatory as the --netrc does.
    #
    # --retry <num>
    #
    #   If a transient error is returned when curl tries to perform a transfer,
    #   it will retry this number of times before giving up. Setting the number
    #   to 0 makes curl do no retries (which is the default). Transient error
    #   means either: a timeout, an FTP 5xx response code or an HTTP 5xx
    #   response code.
    #
    #   When curl is about to retry a transfer, it will first wait one second
    #   and then for all forthcoming retries it will double the waiting time
    #   until it reaches 10 minutes which then will be the delay between the
    #   rest of the retries.  By using --retry-delay you disable this
    #   exponential backoff algorithm. See also --retry-max-time to limit the
    #   total time allowed for retries. (Added in 7.12.3)
    #
    #   If this option is used multiple times, the last occurrence decide the amount.
    #
    # --retry-delay <seconds>
    #
    #   Make curl sleep this amount of time between each retry when a transfer
    #   has failed with a transient error (it changes the default backoff time
    #   algorithm between retries). This option is only interesting if --retry
    #   is also used.  Setting this delay to zero will make curl use the default
    #   backoff time.  (Added in 7.12.3)
    #
    #   If this option is used multiple times, the last occurrence decide the amount.
    #
    # --retry-max-time <seconds>
    #
    #   The retry timer is reset before the first transfer attempt. Retries will
    #   be done as usual (see --retry) as long as the timer hasn't reached this
    #   given limit. Notice that if the timer hasn't reached the limit, the
    #   request will be made and while performing, it may take longer than this
    #   given time period. To limit a single request's maximum time, use
    #   -m/--max-time.  Set this option to zero to not timeout retries. (Added
    #   in 7.12.3)
    #
    #   If this option is used multiple times, the last occurrence decide the amount.
    #
    # -s/--silent
    #   Silent mode. Don't show progress meter or error messages.  Makes Curl mute.
    #
    #   If this option is used twice, the second will again disable silent mode.
    #
    # -S/--show-error
    #   When used with -s it makes curl show error message if it fails.
    #
    #   If this option is used twice, the second will again disable show error.
    #
    # -T/--upload-file <file>
    #
    #   This transfers the specified local file to the remote URL. If there is
    #   no file part in the specified URL, Curl will append the local file
    #   name. NOTE that you must use a trailing / on the last directory to
    #   really prove to Curl that there is no file name or curl will think that
    #   your last directory name is the remote file name to use. That will most
    #   likely cause the upload operation to fail. If this is used on a http(s)
    #   server, the PUT command will be used.
    #
    #   Use the file name "-" (a single dash) to use stdin instead of a given file.
    #
    #   You can specify one -T for each URL on the command line. Each -T + URL
    #   pair specifies what to upload and to where. curl also supports
    #   "globbing" of the -T argument, meaning that you can upload multiple
    #   files to a single URL by using the same URL globbing style supported in
    #   the URL, like this:
    #
    #   curl -T "{file1,file2}" http://www.uploadtothissite.com
    #
    #   or even
    #
    #   curl -T "img[1-1000].png" ftp://ftp.picturemania.com/upload/
    #
    #
    # -y/--speed-time <time>
    #
    #   If a download is slower than speed-limit bytes per second during a
    #   speed-time period, the download gets aborted. If speed-time is used, the
    #   default speed-limit will be 1 unless set with -y.
    #
    #   This option controls transfers and thus will not affect slow connects
    #   etc. If this is a concern for you, try the --connect-timeout option.
    #
    #   If this option is used several times, the last one will be used.
    #
    # -Y/--speed-limit <speed>
    #
    #   If a download is slower than this given speed, in bytes per second, for
    #   speed-time seconds it gets aborted. speed-time is set with -Y and is 30
    #   if not set.
    #
    #   If this option is used several times, the last one will be used.
    #

    #
    # Send file to repository
    # (not really: right now it's still in repository.rb)
    #
    def self.send payload
    end
  end
end
