module WBench
  class AverageTextFormatter
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def to_s
      average_info = data.try(:avg)
      return '' unless average_info
      average_info.map do |browser, results|
        RowTextFormatter.new(Titleizer.new(browser).to_s, results)
      end.join("\n")
    end
  end
end
