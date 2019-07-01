module WBench
  class AverageHtmlFormatter
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def to_s
      <<-TABLE
        <h2>Total statistic</h2>
        <table>
          <thead>
            <th></th>
            <th>Fastest</th>
            <th>Median</th>
            <th>Slowest</th>
            <th>Std Dev</th>
          </thead>
          <tbody>
            <tr><td class="heading" colspan="5">Average times:</td></tr>
            #{avg_text}
          </tbody>
        </table>
      TABLE
    end

    private

    def avg_text
      average_info = data.try(:avg)
      return '' unless average_info
      average_info.map do |browser, results|
        RowHtmlFormatter.new(Titleizer.new(browser).to_s, results)
      end.join('</tr><tr>')
    end
  end
end
