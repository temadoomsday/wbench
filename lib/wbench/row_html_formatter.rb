module WBench
  class RowHtmlFormatter
    def initialize(name, data)
      @name  = name
      @stats = Stats.new(data)
    end

    def to_s
      if @stats.compact.size == 0
        name_s + no_result_s
      else
        name_s + fastest_s + median_s + slowest_s + std_dev_s
      end
    end

    private

    def name_s
      "<td>#{@name}</td>"
    end

    def no_result_s
      "<td colspan='5'>Unable to be recorded</td>"
    end

    def fastest_s
      "<td>#{@stats.min}ms</td>"
    end

    def slowest_s
      "<td>#{@stats.max}ms</td>"
    end

    def median_s
      "<td>#{@stats.median}ms</td>"
    end

    def std_dev_s
      "<td>#{@stats.std_dev.to_i}ms</td>"
    end
  end
end
