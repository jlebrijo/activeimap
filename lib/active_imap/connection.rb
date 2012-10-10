module ActiveImap
  class Connection
    def initialize(user, password, options = {})
      @imap = Net::IMAP.new(ActiveImap.config.server_host, ActiveImap.config.server_port, ActiveImap.config.server_ssl)
      @imap.authenticate('LOGIN', user, password)    
    end
    
    def logout_and_disconnect
      begin
        @imap.logout
        @imap.disconnect
      rescue
      end
    end
    
    def folders(options = {})
      imap = ActiveImap::Folder.all self
    end
    
    def fetchData *args
      @imap.fetch *args
    end
    
    # Send all calls not in this class to Net::IMAP
    def method_missing(method, *args)
      @imap.send(method, *args)
    end
    
    def delete(id)
      @imap.select('INBOX')
      @imap.copy(id, 'INBOX.Trash')
      @imap.store(id, "+FLAGS", [:Deleted])
      @imap.expunge
    end
  end
end