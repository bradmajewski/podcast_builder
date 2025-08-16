class SFTPClient
  attr_reader :server, :log, :logger

  class Error < StandardError
    attr_reader :log

    def initialize(message, log=nil)
      @log = log
      super(message)
    end
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
  end

  def session
    @session ||= start
  end

  def start(&)
    @logger.info("SFTPClient#start - Server ID=#{@server.id} name=#{@server.name_for_ui}")
    Net::SFTP.start(
      server.host,
      server.user,
      port: server.port,
      key_data: [server.private_key],
      logger: @logger,
      **DEFAULTS,
      &)
  rescue Net::SSH::Exception, SystemCallError => e
    @logger.error("SFTPClient#start - #{e.class.name} #{e.message}")
    raise Error.new(e.message, @log.string)
  end
end
