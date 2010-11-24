require 'thread'
require 'fastthread'

module Rutty
  class Worker
    def initialize thread_queue
      @mutex = Mutex.new
      @cv = ConditionVariable.new
      @queue = thread_queue
      @running = true
      
      @thread = Thread.new do
        @mutex.synchronize do
          while @running
            @cv.wait @mutex
            block = get_block
            
            if block
              @mutex.unlock
              block.call
              @mutex.lock
              reset_block
            end
            
            @queue << self
          end
        end
      end
    end

    def name
      @thread.inspect
    end

    def get_block
      @block
    end

    def set_block block
      @mutex.synchronize do
        raise RuntimeError, "Thread already busy." if @block
        @block = block
        # Signal the thread in this class, that there's a job to be done
        @cv.signal
      end
    end

    def reset_block
      @block = nil
    end

    def busy?
      @mutex.synchronize { !@block.nil? }
    end

    def stop
      @mutex.synchronize do
        @running = false
        @cv.signal
      end
      
      @thread.join
    end
  end
end
