module WBench
  class Results
    attr_accessor :url, :loops, :time, :browser, :latency, :app_server

    def initialize(url, loops)
      @url        = url
      @loops      = loops
      @time       = Time.now.asctime
      @browser    = {}
      @latency    = {}
      @app_server = []
    end

    def add(app_server, browser, latency)
      browser.each do |key, value|
        @browser[key] ||= []
        @browser[key] << value
      end

      latency.each do |key, value|
        @latency[key] ||= []
        @latency[key] << value
      end

      @app_server << app_server
    end

    def to_s
      case WBench.format_output
      when :html
        ResultsHtmlFormatter.new(self).to_s
      when :text
        ResultsTextFormatter.new(self).to_s
      else
        raise NotImplementedError, 'Not found format output'
      end
    end
  end
end
