require 'archive/repository/user'
require 'archive/repository/exceptions'
require 'archive/repository/ftp_session'

module Archive

  class Repository

    def exists? payload
    end

    def create payload
      notify_of_creation
    end

    def verify payload
    end

    def fetch payload
    end

  private


    # ---------------------------------------------------------------------------
    #
    # exists? support
    #

    # ---------------------------------------------------------------------------
    #
    # create support
    #

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

    # ---------------------------------------------------------------------------
    #
    # verify support
    #

    def send payload
    end

    # ---------------------------------------------------------------------------
    #
    # URLs for requests
    #

    def url_base
      "http://www.archive.org/"
    end

    def collection_server payload
      case payload.collection
      when :opensource_audio  then 'audio-uploads.archive.org'
      when :opensource_movies then 'movies-uploads.archive.org'
      else                         'items-uploads.archive.org' end
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
