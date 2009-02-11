require 'archive/repository/user'
require 'archive/repository/exceptions'
require 'archive/repository/ftp_session'

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
      transfer_by_ftp payload
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

    def transfer_by_ftp payload
      # ftp_connection do |ftp|
      #   ftp.mkdir payload.identifier
      #   ftp.cd    payload.identifier
      #   ftp.put   Dir[payload.base_path + '*']
      # end
    end

    def tickle_creation_notifier
      # submitting a GET request to the notification_url
      begin
        raw_response = File.read(File.dirname(__FILE__)+'/../../spec/sample/xml_response_success.xml')
      rescue ; nil ; end
      ApiResponse.new(raw_response)
    end

    # Inform the contribution engine of the upload so that it processes
    # contribution, by issuing an HTTP GET tickle
    def notify_of_creation
      response = tickle_creation_notifier
      case
      when response.success?
        # puts "Succeeded: #{response[:url]} - #{response[:message]}"
        response[:url]
      else
        warn "Creation failed with error '#{response[:code]}': #{response[:message]}"
        nil
      end
    end

  public

    def send payload
      cmd = [
        "curl",
        "--ftp-create-dirs",
        "--user '#{username}:#{password}'",
        "--upload-file '#{payload.base_path}/{#{payload.listing.join(",")}}'",
        "'ftp://#{submission_ftp_server(payload)}/#{payload.identifier}/'"
        ].join(" ")
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
      "http://www.archive.org/"
    end

    #
    # The submission host at archive.org for that flavors of payload: movie,
    # audio, other)
    #
    def submission_ftp_server payload
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

    def notification_url payload
      # http://www.archive.org/checkin.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
      # http://www.archive.org/services/contrib-submit.php?user_email=user@user.com&server=movies-uploads.archive.org&dir=MyHomeMovie
      [
        url_base,
        "/services/contrib-submit.php" \
        "?user_email=", username,
        "&server=",     server_name(payload),
        "&dir=",        payload.identifier,
      ].join('')
    end
  end
end
