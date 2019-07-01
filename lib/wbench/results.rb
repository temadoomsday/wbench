module WBench
  class Results
    attr_accessor :url, :loops, :time, :browser, :latency, :app_server, :avg

    def initialize(url, loops)
      @url        = url
      @loops      = loops
      @time       = Time.now.asctime
      @browser    = {}
      @latency    = {}
      @avg        = {}
      @app_server = []
    end

    def add(app_server, browser, latency, avg)
      browser.each do |key, value|
        @browser[key] ||= []
        @browser[key] << value
      end

      latency.each do |key, value|
        @latency[key] ||= []
        @latency[key] << value
      end

      avg.each do |key, value|
        @avg[key] ||= []
        @avg[key] << value
      end

      @app_server << app_server
    end

    def to_s
      to_formatted_s(WBench.format_output)
    end

    def to_formatted_s(format = :text)
      case format
      when :html, 'html'
        ResultsHtmlFormatter.new(self).to_s
      when :text, 'text'
        ResultsTextFormatter.new(self).to_s
      else
        raise NotImplementedError, 'Not found format output'
      end
    end

    def average_formatted_s(format = :text)
      case format
      when :html, 'html'
        AverageHtmlFormatter.new(self).to_s
      when :text, 'text'
        AverageTextFormatter.new(self).to_s
      else
        raise NotImplementedError, 'Not found format output'
      end
    end
  end
end
