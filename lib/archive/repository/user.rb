module Archive
  module Session
    #
    # User "Library Card" identity information for
    # archive.org API transactions.
    #
    # You must create a config/archive-private.yaml file
    # with your username and password -- see the
    #   config/archive-example.yaml
    # file for instructions
    #
    class User
      def username
        Archive.config[:library_card][:username]
      end

      def password
        Archive.config[:library_card][:password]
      end
    end
  end
end
