module WBench
  module Timings
    class Avg
      def initialize(browser)
        @browser = browser
      end

      def result
        TimingAvg.new(timing_json)
      end

      private

      def timing_json
        @browser.evaluate_script('WBench.performanceTimings()')
      end
    end
  end
end
