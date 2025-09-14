module SFTP
  # TODO: Implement this
  # This class needs to be overridden to use a database table. Host key
  # verification in Net::SSH uses a lot of different classes and is difficult
  # to follow. This seems to be the most straightforward way to override.
  class KnownHosts < Net::SSH::KnownHosts
    # Returns an array of all keys that are known to be associatd with the
    # given host. The +host+ parameter is either the domain name or ip address
    # of the host, or both (comma-separated). Additionally, if a non-standard
    # port is being used, it may be specified by putting the host (or ip, or
    # both) in square brackets, and appending the port outside the brackets
    # after a colon. Possible formats for +host+, then, are;
    #
    #   "net.ssh.test"
    #   "1.2.3.4"
    #   "net.ssh.test,1.2.3.4"
    #   "[net.ssh.test]:5555"
    #   "[1,2,3,4]:5555"
    #   "[net.ssh.test]:5555,[1.2.3.4]:5555
    def keys_for(host)
      keys = []
      return keys unless File.readable?(source)

      entries = host.split(/,/)

      File.open(source) do |file|
        scanner = StringScanner.new("")
        file.each_line do |line|
          scanner.string = line

          scanner.skip(/\s*/)
          next if scanner.match?(/$|#/)

          hostlist = scanner.scan(/\S+/).split(/,/)
          found = entries.all? { |entry| hostlist.include?(entry) } ||
            known_host_hash?(hostlist, entries, scanner)
          next unless found

          scanner.skip(/\s*/)
          type = scanner.scan(/\S+/)

          next unless SUPPORTED_TYPE.include?(type)

          scanner.skip(/\s*/)
          blob = scanner.rest.unpack("m*").first
          keys << Net::SSH::Buffer.new(blob).read_key
        end
      end

      keys
    end
  end
end
