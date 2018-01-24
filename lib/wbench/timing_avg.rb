module WBench
  class TimingAvg < Hash
    def initialize(hash)
      # Grab the start time and offset the values against it.
      start_time = hash.select { |_, value| value.positive? }
                       .min_by(&:last)
                       .last
      hash = hash.map { |key, value| [key, value.zero? ? value : value - start_time] }

      # Remove Start|End out name properties
      hash = hash.each_with_object({}) do |data, acc|
               key, value = data
               key.gsub!(/start|end/i, '')

               times = acc[key] ||= []
               times << value
             end

      # Calculate time intervals
      hash = hash.each_with_object({}) do |data, acc|
        key, values = data

        times = acc[key] ||= []
        times << values.inject(:-).abs
      end

      hash
      # # Order the results by value, lowest to highest
      # hash.sort_by(&:last).each { |key, value| self[key] = value }
    end
  end
end
