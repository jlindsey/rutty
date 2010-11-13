require 'rutty/consts'

module Rutty
  
  ##
  # The primary mixin module containing the code executed by the rutty bin's actions.
  #
  # @author Josh Lindsey
  # @since 2.0.0
  module Actions
    ##
    # Initialize the Rutty config file structure in the specified directory, or
    # report that the files already exist there.
    #
    # @see Rutty::Runner#config_dir
    # @param [String] dir The directory to install into. {Rutty::Runner#config_dir} ensures
    #   that this falls back to {Rutty::Consts::CONF_DIR} if not passed in by the user.
    def init dir
      require 'yaml'
      
      general_file = File.join(dir, Rutty::Consts::GENERAL_CONF_FILE)
      nodes_file = File.join(dir, Rutty::Consts::NODES_CONF_FILE)
      
      if File.exists? dir
        log "\t<%= color('exists', :cyan) %>", dir
      else
        log "\t<%= color('create', :green) %>", dir
        Dir.mkdir dir
      end

      if File.exists? general_file
        log "\t<%= color('exists', :cyan) %>", general_file
      else
        log "\t<%= color('create', :green) %>", general_file

        defaults_hash = { 
          :user => 'root', 
          :keypath => File.join(ENV['HOME'], '.ssh', 'id_rsa'), 
          :port => 22
        }

        File.open(general_file, 'w') do |f|
          YAML.dump(defaults_hash, f)
        end
      end

      if File.exists? nodes_file
        log "\t<%= color('exists', :cyan) %>", nodes_file
      else
        log "\t<%= color('create', :green) %>", nodes_file

        File.open(nodes_file, 'w') do |f|
          YAML.dump([], f)
        end
      end
    end

    ##
    # Add a new user-defined node to the datastore file.
    #
    # @see http://visionmedia.github.com/commander/
    # @param [Array] args ARGV passed by the bin
    # @param [Object] options The parsed options object as passed by the bin
    def add_node args, options
      raise Rutty::BadUsage.new "Must supply a hostname or IP address. 
      See `rutty help add_node' for usage" if args.empty?

      hash = { :host => args.first }
      hash[:keypath] = options.keypath unless options.keypath.nil?
      hash[:user] = options.user unless options.user.nil?
      hash[:port] = options.port unless options.port.nil?
      hash[:tags] = options.tags unless options.tags.nil?
      
      self.nodes << Rutty::Node.new(hash, self.config.to_hash)
      self.nodes.write_config self.config_dir
      
      say "<%= color('Added #{hash[:host]}', :green) %>"
    end

    ##
    # List all the user-defined nodes currently stored in the datastore file.
    #
    # @see (see #add_node)
    # @param (see #add_node)
    def list_nodes args, options
      check_installed!
      
      if self.nodes.empty?
        say "<%= color('No nodes defined', :yellow) %>"
      else
        output = case self.output_format
          when 'human-readable'
            require 'terminal-table/import'
      
            table do |t|
              t.headings = 'Host', 'Key', 'User', 'Port', 'Tags'
              self.nodes.each do |node|
                tags = node.tags.nil? ? [] : node.tags
                t << [node.host, node.keypath, node.user, node.port, tags.join(', ')]
              end
            end
          
          when 'json'
           require 'json'
           JSON.dump self.nodes.collect { |node| node.to_hash }
           
          when 'xml'
            require 'builder'
            xml = Builder::XmlMarkup.new(:indent => 2)
           
             xml.instruct!
             xml.nodes do
               self.nodes.each do |node|
                 xml.node do
                   xml.host node.host
                   xml.user node.user
                   xml.port node.port
                   xml.keypath node.keypath
                   xml.tags do
                     node.tags.each do |tag|
                       xml.tag tag
                     end
                   end
                 end
               end
             end
        end
        
        puts output
      end
    end

    ##
    # Cycle through all the user-defined nodes, filtered by the options, connect to them
    # and run the specified command on them.
    #
    # @see (see #add_node)
    # @param (see #add_node)
    def dsh args, options
      check_installed!
      raise Rutty::BadUsage.new "Must supply a command to run. See `rutty help dsh' for usage" if args.empty?
      raise Rutty::BadUsage.new "One of -a or --tags must be passed" if options.a.nil? and options.tags.nil?
      raise Rutty::BadUsage.new "Use either -a or --tags, not both" if !options.a.nil? and !options.tags.nil?
      raise Rutty::BadUsage.new "Multi-word commands must be enclosed in quotes (ex. rutty -a \"ps -ef | grep httpd\")" if args.length > 1

      if self.nodes.empty?
        say "<%= color('No nodes defined', :yellow) %>"
        exit
      end
      
      HighLine.color_scheme = HighLine::SampleColorScheme.new

      com_str = args.pop

      require 'logger'
      require 'net/ssh'

      @returns = {}
      connections = []

      # This is necessary in order to capture exit codes and/or signals, 
      # which are't passed through when using just the ssh.exec!() semantics.
      exec_command = lambda { |ssh| 
        ssh.open_channel do |channel| 
          channel.exec(com_str) do |ch, success| 
            unless success 
              abort "FAILED: couldn't execute command (ssh.channel.exec failure)" 
            end 

            channel.on_data do |ch, data|  # stdout 
              @returns[ssh.host][:out] << data
            end 

            channel.on_extended_data do |ch, type, data| 
              next unless type == 1  # only handle stderr 
              @returns[ssh.host][:out] << data
            end 

            channel.on_request("exit-status") do |ch, data| 
              exit_code = data.read_long 
              @returns[ssh.host][:exit] = exit_code
            end 

            channel.on_request("exit-signal") do |ch, data| 
              @returns[ssh.host][:sig] = data.read_long
            end 
          end 
        end 
        ssh.loop
      }

      self.nodes.filter(options).each do |node|
        @returns[node.host] = { :exit => 0, :out => '' }
        begin
          connections << Net::SSH.start(node.host, node.user, :port => node.port, :paranoid => false, 
          :user_known_hosts_file => '/dev/null', :keys => [node.keypath], :timeout => 5,
          :logger => Logger.new(options.debug.nil? ? $stderr : $stdout),
          :verbose => (options.debug.nil? ? Logger::FATAL : Logger::DEBUG))
        rescue Errno::ECONNREFUSED
          @returns[node.host][:out] = "ERROR: Connection refused"
          @returns[node.host][:exit] = 10000
        rescue SocketError
          @returns[node.host][:out] = "ERROR: no nodename nor servname provided, or not known"
          @returns[node.host][:exit] = 20000
        rescue Timeout::Error
          @returns[node.host][:out] = "ERROR: Connection timeout"
          @returns[node.host][:exit] = 30000
        end
      end

      connections.each { |ssh| exec_command.call(ssh) }

      loop do
        connections.delete_if { |ssh| !ssh.process(0.1) { |s| s.busy? } }
        break if connections.empty?
      end
      
      output = case self.output_format
        when 'human-readable'
          min_width = 0
          @returns.each do |host, hash|
            min_width = host.length if host.length > min_width
          end
      
          buffer = ''
          @returns.each do |host, hash|
            padded_host = host.dup
      
            if hash[:exit] >= 10000
              padded_host = "<%= color('#{padded_host}', :critical) %>"
              hash[:out] = "<%= color('#{hash[:out]}', :red) %>"
            elsif hash[:exit] > 0
              padded_host = "<%= color('#{padded_host}', :error) %>"
            else
              padded_host = "<%= color('#{padded_host}', :green) %>"
            end
        
            padded_host << (" " * (min_width - host.length)) if host.length < min_width
            buffer << padded_host << "\t\t"
        
            buffer << hash[:out].lstrip
          end
          
          buffer
          
        when 'json'
          require 'json'
          JSON.dump @returns
          
        when 'xml'
          require 'builder'
          
          xml = Builder::XmlMarkup.new(:indent => 2)
          
          xml.instruct!
          xml.nodes do
            @returns.each do |host, hash|
              xml.node do
                xml.host host
                xml.exit hash[:exit]
                xml.out hash[:out].strip
              end
            end
          end
      end
      
      say output
    end

    ##
    # Cycle through all the user-defined nodes, filtered by the options, connect to them
    # and upload the specified file(s).
    #
    # @see (see #add_node)
    # @param (see #add_node)
    def scp args, options
      check_installed!
      raise Rutty::BadUsage.new "Must supply a local path and a remote path" unless args.length == 2
      raise Rutty::BadUsage.new "One of -a or --tags must be passed" if options.a.nil? and options.tags.nil?
      raise Rutty::BadUsage.new "Use either -a or --tags, not both" if !options.a.nil? and !options.tags.nil?

      require 'logger'
      require 'net/ssh'
      require 'net/scp'
      require 'pp'

      connections = []

      remote_path = args.pop
      local_path = args.pop

      self.nodes.filter(options).each do |node|
        begin
          connections << Net::SSH.start(node.host, node.user, :port => node.port, :paranoid => false, 
          :user_known_hosts_file => '/dev/null', :keys => [node.keypath], 
          :logger => Logger.new(options.debug.nil? ? $stderr : $stdout),
          :verbose => (options.debug.nil? ? Logger::FATAL : Logger::DEBUG))
        rescue Errno::ECONNREFUSED
          $stderr.puts "ERROR: Connection refused on #{node.host}"
        rescue SocketError
          $stderr.puts "ERROR: nodename nor servname provided, or not known for #{node.host}"
        end
      end

      connections.each { |ssh| ssh.scp.upload! local_path, remote_path }

      loop do
        connections.delete_if { |ssh| !ssh.process(0.1) { |s| s.busy? } }
        break if connections.empty?
      end
    end
  end
end
