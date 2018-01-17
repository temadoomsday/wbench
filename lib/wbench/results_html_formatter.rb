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
        <h3>Testing #{@results.url}</h2>
        <p>At #{@results.time} #{@results.loops} loops</p>
        <table>
          <thead>
            <th></th>
            <th>Fastest</th>
            <th>Median</th>
            <th>Slowest</th>
            <th>Std Dev</th>
          </thead>
          <tbody>
            <tr>
              <td colspan='5'>Server performance:<td>
            </tr>
            <tr>
              #{app_server_s}
            </tr>
            <tr>
              <td colspan='5'>Host latency:<td>
            </tr>
            <tr>
              #{latency_s}
            </tr>
            <tr>
              <td colspan='5'>Browser performance:<td>
            </tr>
            <tr>
              #{browser_rows_s}
            </tr>
          </tbody>
        </table>
      TABLE
    end

    def app_server_s
      RowHtmlFormatter.new('Total application time', @results.app_server)
    end

    def latency_s
      items = @results.latency.map do |domain, values|
                RowHtmlFormatter.new(domain, values)
              end
      items.join('</tr><tr>')
    end

    def browser_rows_s
      items = @results.browser.map do |browser, results|
                RowHtmlFormatter.new(Titleizer.new(browser).to_s, results)
              end
      items.join('</tr><tr>')
    end
  end
end
