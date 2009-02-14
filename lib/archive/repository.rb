require 'archive/repository/user'
require 'archive/repository/exceptions'
require 'archive/repository/ftp_session'
require 'net/http'

module Archive

  class Repository

    #
    # Checks if the payload exists
    #
    # Note that this does *not* reserve the identifier,
    # so race conditions may exist.
    #
    def exists? payload
    end

    def create payload
      send payload
      notify_of_creation
    end

    #
    # Verifies that a payload was successfully created
    #
    def verify payload
    end

    def fetch payload
    end

  protected
    #
    # FIXME -- should be own user?
    #
    def username
      Archive.config[:library_card][:username]
    end

    #
    # FIXME -- should be own user?
    #
    def password
      Archive.config[:library_card][:password]
    end


    # ---------------------------------------------------------------------------
    #
    # exists? support
    #

    # ---------------------------------------------------------------------------
    #
    # create support
    #
  public
    def tickle_creation_notifier payload
      # submitting a GET request to the notification_url
      # begin
        url = URI.parse(notification_url(payload))
      p [url, url.path]
        req = Net::HTTP::Get.new(url.to_s)
        raw_response = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
      puts raw_response
        ApiResponse.new(raw_response.body)
      # rescue ; nil ; end
    end

    # Inform the contribution engine of the upload so that it processes
    # contribution, by issuing an HTTP GET tickle
    def notify_of_creation payload
      response = tickle_creation_notifier(payload)
      case
      when response && response.success?
        # puts "Succeeded: #{response[:url]} - #{response[:message]}"
        response[:url]
      else
        warn "Creation failed with error '#{response[:code]}': #{response[:message]}"
        nil
      end
    end

  public

    #
    # Send file to repository
    # -- see ftp.rb for cmd line docs.
    #
    def self.send payload
      cmd = [
        "curl",
        "--ftp-create-dirs",
        "--user        '#{username}:#{password}'",
        "--upload-file '#{payload.base_path}/{#{payload.listing.join(",")}}'",
        "'ftp://#{server_name(payload)}/#{payload.identifier}/'"
      ].join(" ")
      $stderr.puts cmd
      puts `#{cmd}`
    end

    # ---------------------------------------------------------------------------
    #
    # verify support
    #

    # ---------------------------------------------------------------------------
    #
    # URLs for requests
    #

    def url_base
      "http://www.archive.org"
    end

    #
    # The submission host at archive.org for that flavors of payload: movie,
    # audio, other)
    #
    def server_name payload
      # Make sure to go most to least specific
      case payload
      when Archive::MoviePayload         then "movies-uploads.archive.org"
      when Archive::AudioPayload         then "audio-uploads.archive.org"
      when Archive::GenericPayload       then "items-uploads.archive.org"
      else raise "Need to define a server for payloads of type #{payload.class.to_s}"
      end
    end

    def creation_url
      [
        'http://www.archive.org/create.php',
        '?identifier=', archive_identifier,
        '&xml=',        1,
        '&user=',       archive_user,
      ].join("")
    end

    # The verification URL for a given archive.org payload identifier.
    def verification_url payload
      [
        url_base,
        '/', payload.mediatype,
        '/', payload.mediatype, "-details-db.php",
        "?collection=",   payload.collection,
        '&collectionid=', payload.identifier
      ].join('')
    end

    def exists_url payload
      [
        url_base,
        "/services/check_identifier.php",
        "?identifier=", payload.identifier
      ].join('')
    end

    # tickle_creation_notifier
    #   http://www.archive.org/services/contrib-submit.php?user_email=archiver@infochimps.org&server=items-uploads.archive.org&dir=sample_002
    #   http://www.archive.org/services/contrib-submit.php?user_email=dhruv@infochimps.org&server=items-uploads.archive.org&dir=sample_002
    def notification_url payload
      # http://www.archive.org/checkin.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
      # http://www.archive.org/services/contrib-submit.php?user_email=user@user.com&server=movies-uploads.archive.org&dir=MyHomeMovie
      [
        url_base,
        "/services/contrib-submit.php" \
        "?user_email=", username,
        # "&server=",     server_name(payload),
        "&dir=",        payload.identifier,
      ].join('')
    end
  end
end
