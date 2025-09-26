module LlmGateway
  class Metrics
    def initialize
      @counters = Hash.new(0)
      @timings = []
    end

    def increment(key)
      @counters[key] += 1
    end

    def record_timing(key, time)
      @timings << { key: key, time: time }
    end

    def stats
      {
        counters: @counters,
        avg_timings: average_timings
      }
    end

    private

    def average_timings
      @timings.group_by { |t| t[:key] }.transform_values do |times|
        times.sum { |t| t[:time] } / times.size
      end
    end
  end
end