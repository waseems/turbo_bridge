# The Util class holds generally useful turbobridge things,
# such as their cononical phone format.
module TurboBridge
  class Util
    def self.format_phone_number(number)
      # 4152980615
      # 1234567890
      number.to_s.gsub(/[^0-9]/,'').sub(/^(1)?([0-9]{10})$/,"+#{$1 || 1}\\2")
    end
  end
end
