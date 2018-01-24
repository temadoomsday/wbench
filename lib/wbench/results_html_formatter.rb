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
        #{style_s if WBench.style_output}
        #{header_s if WBench.header_output}
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
            <tr>#{browser_s}</tr>
            <tr>#{spacer_s}</tr>
            <tr>#{avg_heading_s}</tr>
            <tr>#{avg_s}</tr>
          </tbody>
        </table>
      TABLE
    end

    def style_s
      <<-STYLE
        <style>
          header { padding-bottom: 20px; }
          header h3 { margin-bottom: 10px; }
          header h3 span { color: #17a2b8; }
          header h3 span:after { content: '"' }
          header h3 span:before { content: '"' }
          header ul { margin: 0; padding: 0; }
          header li { list-style: none; }
          tr { height: 20px; }
          th { text-align: left; }
          td { min-width: 80px; }
          td:first-child { min-width: 250px; }
          td:nth-of-type(2) { color: #28a745; }
          td:nth-of-type(3) { color: #17a2b8; }
          td:nth-of-type(4) { color: #dc3545; }
          td:nth-of-type(5) { color: #ffc107; }
          .heading { font-weight: 700; }
        </style>
      STYLE
    end

    def header_s
      <<-HEADER
        <header>
          <h3>Testing <span>#{@results.url}</span></h3>
          <ul>
            <li>At #{@results.time}</li>
            <li>#{@results.loops} loops</li>
          </ul>
        </header>
      HEADER
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

    def browser_s
      items = @results.browser.map do |browser, results|
                RowHtmlFormatter.new(Titleizer.new(browser).to_s, results)
              end
      items.join('</tr><tr>')
    end

    def avg_heading_s
      '<td class="heading" colspan="5">Average times:</td>'
    end

    def avg_s
      items = @results.avg.map do |browser, results|
                RowHtmlFormatter.new(Titleizer.new(browser).to_s, results)
              end
      items.join('</tr><tr>')
    end
  end
end
