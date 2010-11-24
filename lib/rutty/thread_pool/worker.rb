require 'thread'
require 'fastthread'

module Rutty
  
  ##
  # The {ThreadPool} Thread wrapper, representing a single thread of execution in the pool.
  #
  # @since 2.4.0
  class Worker
    
    ##
    # Initialize a new {Worker}. Sets up the initial state of this instance, then spins out its thread. The thread will
    # wait until it's signaled (by being passed a new closure to execute, or being told to die, etc.), then resume execution
    # of its task. The Thread is wrapped in a <tt>while @running</tt> loop, allowing for easy termination from {#shutdown}.
    #
    # @param [Queue] thread_queue The thread queue from the {ThreadPool} instance to add this worker to
    # @return [Worker] The new, available Worker object.
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

    ##
    # Returns the evaluation of <tt>@thread.inspect</tt>.
    #
    # @return [String] This thread's name
    def name
      @thread.inspect
    end

    ##
    # Returns the value of <tt>@block</tt>.
    #
    # @return [Proc, Lambda, #call] The <tt>@block</tt> object previously passed.
    def get_block
      @block
    end

    ##
    # Sets a new closure as the task for this worker. Signals the Thread to wakeup after assignment.
    # 
    # @param (see Rutty::ThreadPool#process)
    # @raise [RuntimeError] If the thread is currently busy when called.
    def set_block block
      @mutex.synchronize do
        raise RuntimeError, "Thread already busy." if @block
        @block = block
        # Signal the thread in this class, that there's a job to be done
        @cv.signal
      end
    end
    
    ##
    # Sets the <tt>@block</tt> to <tt>nil</tt>. Called after the Thread has finished execution of a task to
    # ready itself for the next one.
    def reset_block
      @block = nil
    end

    ##
    # Whether or not this Thread is currently executing. Determined by whether <tt>@block</tt> is <tt>nil</tt>.
    #
    # @return [Boolean] Is this Thread executing?
    def busy?
      @mutex.synchronize { !@block.nil? }
    end

    ##
    # Sets <tt>@running</tt> to <tt>false</tt>, causing the Thread to finish after the current loop. Signals
    # the Thread to wake and resume, then calls <tt>#join</tt>.
    #
    # @see #initialize
    def stop
      @mutex.synchronize do
        @running = false
        @cv.signal
      end
      
      @thread.join
    end
  end
end
