require 'thread'
require 'fastthread'
require 'rutty/thread_pool/worker'

module Rutty

  ##
  # A thread pool implementation using the work queue pattern. Shamelessly stolen from a StackOverflow question.
  #
  # @see http://stackoverflow.com/questions/81788/deadlock-in-threadpool/82777#82777
  # @since 2.4.0
  class ThreadPool
    ## @return [Integer] The maximum number of concurrent {Worker} threads
    attr_accessor :max_size

    ##
    # Creates a new {ThreadPool} instance with a maximum number of {Worker} threads.
    def initialize max_size = 10
      Thread.abort_on_exception = true
      
      @max_size = max_size
      @queue = Queue.new
      @workers = []
    end

    ##
    # The current size of the <tt>@workers</tt> array.
    #
    # @return [Integer] The current number of {Worker} threads
    def current_size
      @workers.size
    end

    ##
    # Whether any {Worker} threads are currently executing, determined by 
    # comparing the sizes of the <tt>@workers</tt> array and the <tt>@queue</tt>.
    #
    # @return [Boolean] Any currently executing workers?
    def busy?
      @queue.size < current_size
    end

    ##
    # Loops over every {Worker} and calls {Worker#stop}, then clears the <tt>@workers</tt> array.
    def shutdown
      @workers.each { |w| w.stop }
      @workers = []
    end
    
    alias :join :shutdown

    ##
    # Gets a free worker and passes it the specified closure.
    #
    # @see #get_worker
    # @param [Proc, Lambda, #call] block An instance of any class that responds to <tt>#call</tt>
    def process block = nil, &blk
      block = blk if block_given?
      get_worker.set_block block
    end

    private

    ##
    # Gets a free {Worker}. If the {#max_size} has been reached and the <tt>@queue</tt> isn't empty,
    # pops an existing {Worker} from there. Otherwise spins up a new {Worker} and adds it to the <tt>@workers</tt>
    # array.
    #
    # @return [Rutty::Worker] A {Worker} ready for a new job
    def get_worker
      if !@queue.empty? or current_size == @max_size
        return @queue.pop
      else
        worker = Rutty::Worker.new @queue
        @workers << worker
        worker
      end
    end
  end
end
