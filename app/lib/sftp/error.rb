module SFTP
  class Error < StandardError
    attr_reader :log, :code, :description, :response, :text

    # Use with care. The log is duplicated and frozen to avoid reading log
    # messages written after the exception has occurred.
    def initialize(message, log=nil)
      @log = (log.is_a?(StringIO) ? log.string : log).dup.freeze if log
      super(message)
    end

    # Used to rescue StatusException with specific codes. See SFTP::ERRORS for
    # list of status codes
    #
    # Example: `rescue Error.catch(FX_NO_SUCH_FILE) => e`
    def self.catch(*status_codes)
      Class.new do
        def self.===(exception)
          exception.is_a?(Net::SFTP::StatusException) &&
            @status_codes.include?(exception.code)
        end
      end.tap do |c|
        c.instance_variable_set(:@status_codes, status_codes)
      end
    end

    # Wrap SSH, SFTP, and IO exceptions. Other exception types are returned unmodified.
    def self.from(status_exception, log=nil)
      case status_exception
      when Net::SFTP::StatusException
        msg = [
          ERRORS.fetch(status_exception.code, "Unknown Error (#{status_exception.code})"),
          status_exception.text.presence
        ].compact.join(": ")

        new(msg, log)
      when IOError, SystemCallError, Net::SSH::Exception
        new("#{status_exception.class.name}: #{status_exception.message}", log)
      else
        status_exception
      end
    end
  end
end
