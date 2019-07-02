module WBench
  class RowHtmlFormatter
    include WBench::ResultFormatter

    def initialize(name, data)
      @name = name
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
      "<td>#{formatted_result(@stats.min)}</td>"
    end

    def slowest_s
      "<td>#{formatted_result(@stats.max)}</td>"
    end

    def median_s
      "<td>#{formatted_result(@stats.median)}</td>"
    end

    def std_dev_s
      "<td>#{formatted_result(@stats.std_dev.to_i)}</td>"
    end
  end
end
