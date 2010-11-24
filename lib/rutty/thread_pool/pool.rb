require 'thread'
require 'fastthread'
require 'rutty/thread_pool/worker'

module Rutty
  class ThreadPool
    attr_accessor :max_size

    def initialize max_size = 10
      Thread.abort_on_exception = true
      
      @max_size = max_size
      @queue = Queue.new
      @workers = []
    end

    def size
      @workers.size
    end

    def busy?
      @queue.size < @workers.size
    end

    def shutdown
      @workers.each { |w| w.stop }
      @workers = []
    end
    
    alias :join :shutdown

    def process block=nil,&blk
      block = blk if block_given?
      get_worker.set_block block
    end

    private

    def get_worker
      if !@queue.empty? or @workers.size == @max_size
        return @queue.pop
      else
        worker = Rutty::Worker.new @queue
        @workers << worker
        worker
      end
    end
  end
end
