require 'archive/repository/user'
require 'archive/repository/exceptions'
require 'archive/repository/ftp_session'

module Archive
  class Repository

    def exists? payload
    end

    def create payload
    end

    def verify payload
    end

    def fetch payload
    end

  private
    def ftp_uri_str
      [
        'http://www.archive.org/create.php',
        '?identifier=', archive_identifier,
        '&xml=',        1,
        '&user=',       archive_user,
      ].join("")
    end

    def collection_server item
      case item.collection
      when :opensource_audio  then 'audio-uploads.archive.org'
      when :opensource_movies then 'movies-uploads.archive.org'
      else                         'items-uploads.archive.org' end
    end

    def available? item
      # concatenate the service URL
      checkurl = "http://www.archive.org/services/check_identifier.php?" \
      "identifier=%s" % identifier

      # make request
      response = urllib2.urlopen(checkurl)
      response_dom = xml.dom.minidom.parse(response)

      # parse the response DOM
      result = response_dom.getElementsByTagName("result")[0]
      result_type = result.getAttribute("type")
      result_code = result.getAttribute("code")

      case
      when result_type == 'error'
        raise "MissingParameterException"
      when (result_type == 'success') && (result_code == 'available')
        return true
      else return false
      end
    end

    # ---------------------------------------------------------------------------
    #
    # Verify
    #

    def url_base
      "http://www.archive.org/"
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

    def notification_url
      # http://www.archive.org/checkin.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
      [
        url_base,
        "/services/contrib-submit.php" \
        "?user_email=", username,
        "&server=",     server_name(payload),
        "&dir=",        payload.identifier,
      ].join('')
    end

    # Return a hash
    def self.parse_response response_xml, context
    end

    # Tickle the "payload submitted" monitor
    def notify_of_creation
      # # submitting a GET request to the notification_url
      # begin
      #   response_xml = ...
      # rescue ; nil ; end
      # # examine response
      # response = self.class.parse_response(response_xml, :notification) if response_xml
      # # check if error
      # # success: save
      # # error: raise.
    end

    def send payload
    end
  end
end
