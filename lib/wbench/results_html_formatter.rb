module WBench
  class ResultsHtmlFormatter
    def initialize(results)
      @results = results
    end

    def to_s
      html_table
    end

    private

    def html_table
      <<-TABLE
        <ul>
          <li><h3>Testing <small>#{@results.url}</small></h3></li>
          <li>At #{@results.time} </li>
          <li>#{@results.loops} loops</li>
        </ul>
        <table>
          <thead>
            <th></th>
            <th>Fastest</th>
            <th>Median</th>
            <th>Slowest</th>
            <th>Std Dev</th>
          </thead>
          <tbody>
            <tr>#{app_heading_s}</tr>
            <tr>#{app_server_s}</tr>
            <tr>#{spacer_s}</tr>
            <tr>#{latency_heading_s}</tr>
            <tr>#{latency_s}</tr>
            <tr>#{spacer_s}</tr>
            <tr>#{browser_heading_s}</tr>
            <tr>#{browser_rows_s}</tr>
          </tbody>
        </table>
      TABLE
    end

    def spacer_s
      '<td colspan="6"></td>'
    end

    def app_heading_s
      '<td class="heading" colspan="5">Server performance:</td>'
    end

    def app_server_s
      RowHtmlFormatter.new('Total application time', @results.app_server)
    end

    def latency_heading_s
      '<td class="heading" colspan="5">Host latency:</td>'
    end

    def latency_s
      items = @results.latency.map do |domain, values|
                RowHtmlFormatter.new(domain, values)
              end
      items.join('</tr><tr>')
    end

    def browser_heading_s
      '<td class="heading" colspan="5">Browser performance:</td>'
    end

    def browser_rows_s
      items = @results.browser.map do |browser, results|
                RowHtmlFormatter.new(Titleizer.new(browser).to_s, results)
              end
      items.join('</tr><tr>')
    end
  end
end
