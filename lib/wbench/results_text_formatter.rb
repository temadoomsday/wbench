module WBench
  class ResultsTextFormatter
    def initialize(results)
      @results = results
    end

    def to_s
      [ heading_s,
        spacer_s,
        app_heading_s,
        app_server_s,
        spacer_s,
        latency_heading_s,
        latency_s,
        spacer_s,
        browser_heading_s,
        browser_rows_s ].join
    end

    private

    def heading_s
      s = "\n"
      s += "Testing #{@results.url}\nAt #{@results.time}\n#{@results.loops} loops\n" if WBench.header_output
      s += ''.center(35)
      s += 'Fastest'.ljust(10)
      s += 'Median'.ljust(10)
      s += 'Slowest'.ljust(10)
      s += 'Std Dev'.ljust(10)
      s += "\n"
      s += '-' * 75
      s
    end

    def spacer_s
      "\n\n"
    end

    def browser_rows_s
      @results.browser.map { |browser, results| RowTextFormatter.new(Titleizer.new(browser).to_s, results) }.join("\n")
    end

    def app_server_s
      RowTextFormatter.new('Total application time', @results.app_server)
    end

    def latency_s
      @results.latency.map { |domain, values| RowTextFormatter.new(domain, values) }.join("\n")
    end

    def latency_heading_s
      ColoredString.new("Host latency:\n", :yellow)
    end

    def browser_heading_s
      ColoredString.new("Browser performance:\n", :yellow)
    end

    def app_heading_s
      ColoredString.new("Server performance:\n", :yellow)
    end
  end
end
