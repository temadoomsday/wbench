module WBench
  module ResultFormatter
    def rounded_result(result)
      (result * WBench.discharge_multiplier).round(WBench.rounding_characters_number)
    end

    def formatted_result(result)
      "#{rounded_result(result)}#{WBench.unit_name}"
    end
  end
end
