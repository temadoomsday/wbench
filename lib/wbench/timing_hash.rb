module WBench
  class TimingHash < Hash
    def initialize(hash)
      # Grab the start time and offset the values against it.
      start_time = hash.reject { |_, v| v == 0 }.min_by(&:last).last
      hash = hash.map do |key, value|
        [key, value != 0 ? value - start_time : value]
      end

      # Order the results by value, lowest to highest
      hash.sort_by(&:last).each { |key, value| self[key] = value }
    end
  end
end
