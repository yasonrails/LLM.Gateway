module LlmGateway
  class CircuitBreaker
    def initialize(failure_threshold = 5, recovery_timeout = 60)
      @failure_threshold = failure_threshold
      @recovery_timeout = recovery_timeout
      @failures = 0
      @last_failure_time = nil
      @state = :closed
    end

    def call
      if open?
        raise "Circuit breaker is open"
      end

      begin
        result = yield
        on_success
        result
      rescue => e
        on_failure
        raise e
      end
    end

    private

    def open?
      @state == :open && !should_attempt_reset?
    end

    def should_attempt_reset?
      @state == :open && Time.now - @last_failure_time > @recovery_timeout
    end

    def on_success
      @failures = 0
      @state = :closed
    end

    def on_failure
      @failures += 1
      @last_failure_time = Time.now
      if @failures >= @failure_threshold
        @state = :open
      end
    end
  end
end