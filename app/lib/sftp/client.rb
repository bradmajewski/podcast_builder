require 'shellwords'

module SFTP
  # Partial abstraction for Net::SFTP::Session. Only implements operations that
  # the application needs.
  class Client
    extend MethodDecorators::Client
    attr_reader :server, :log, :logger, :session

    # Duck type, if you don't want to use ActiveRecord
    Server =
      Struct.new(:host, :port, :user, :private_key, keyword_init: true) do |c|
        def id = 0
        def name_for_ui = "#{user}@#{host}"
      end

    DEFAULTS = {
      auth_methods: ['publickey'],
      config: false, # OpenSSH config files (~/.ssh/config, /etc/ssh_config)
      keys_only: true,
      non_interactive: true,
      timeout: 10.seconds, # connect_timeout for Socket.tcp
      use_agent: false, # ssh-agent
      # known_hosts: KnownHosts,
      verify_host_key: :never, # Disable until custom KnownHosts is implemented.
    }

    def initialize(server)
      @server = server
      @session = nil
      @log = StringIO.new
      @logger = Logger.new(@log, level: Logger::INFO) # Debug is too detailed: received sftp packet 2 len 150
      info("SERVER ID=#{@server.id} NAME=#{@server.name_for_ui}")
    end

    operation def start(&block)
      if block_given?
        start_session do |session|
          @session = session
          block.call(self, session).tap { @session = nil }
        end
      else
        @session = start_session
        self
      end
    end

    def close
      ssh&.close
    end

    def start_session(&)
      Net::SFTP.start(
        server.host,
        server.user,
        port: server.port,
        key_data: [clean_private_key(server.private_key)],
        logger: @logger,
        **DEFAULTS,
        &
      )
    end

    def ssh
      @session&.session
    end

    def rm_f(path)
      ssh.exec!("rm -f #{Shellwords.escape(path)}")
    end

    operation def list_files(path)
      session.dir.glob(path, "*").map(&:name)
    end

    # Returns file type as a string. May also return 'not_found' or
    # 'permission_denied'.
    operation def file_type(path)
      TYPES.fetch(stat_file(path).type) do |type|
        raise Error.new("Undocumented type: #{type}", @log)
      end
    rescue Error.catch(FX_NO_SUCH_FILE)
      'not_found'
    rescue Error.catch(FX_PERMISSION_DENIED)
      'permission_denied'
    end

    def upload(local, remote)
      client.upload!(local, remote)
    end

    def stat_file(path)
      session.stat!(path)
    end

    operation def read_file(path)
      session.file.open(path, "r") do |file|
        file.read
      end
    rescue Error.catch(FX_NO_SUCH_FILE)
      nil
    end

    operation def write_file(path, contents)
      session.file.open(path, "w") do |file|
        info("Writing #{contents.bytesize} bytes")
        file.write(contents)
      end
    end

    operation def find_or_create_path(path)
      current_path = String.new
      path.split("/").each do |dir|
        current_path += dir + "/"
        find_or_create_dir(current_path)
      end
    rescue Error.catch(FX_NO_SUCH_FILE)
      raise Error.new("No such file or directory: #{path}", @log)
    end

    operation def find_or_create_dir(name)
      unless (type = session.stat!(name).type) == SFTP::T_DIRECTORY
        raise Error, "Needed directory, got #{TYPES[type]}"
      end
    rescue Error.catch(FX_NO_SUCH_FILE)
      session.mkdir!(name)
    end

    private
    def info(msg)    = @logger.info(msg)
    def warning(msg) = @logger.warn(msg)
    def error(msg)   = @logger.error(msg)
    def fatal(msg)   = @logger.fatal(msg)

    def exception(e)
      fatal("#{e.class.name}: #{e.message}\n#{e.backtrace.join("\n")}")
    end

    def clean_private_key(key)
      key.gsub("\r", "").strip
    end

  end
end
