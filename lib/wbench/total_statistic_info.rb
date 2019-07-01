module WBench
  class TotalStatisticInfo
    attr_accessor :results, :average_metric

    def initialize(results)
      @results = results
    end

    def to_s
      calculate_average_metric
      average_metric ? average_metric.average_formatted_s(WBench.format_output) : ''
    end

    private

    def calculate_average_metric
      return unless results.any?
      @average_metric = results.first.dup

      results.drop(1).each do |result|
        avg_results = result.try(:avg)
        next if avg_results.blank?
        avg_results.keys.each do |avg_key|
          value = avg_results[avg_key]
          next unless value.is_a?(Array)
          if average_metric.avg[avg_key]
            average_metric.avg[avg_key] += value
          else
            average_metric.avg[avg_key] = value
          end
        end
      end
    end
  end
end
