# LiveManager implements the turbobridge LCM (live conference manager) API
module TurboBridge
  class LiveManager
    attr_accessor :bridge, :conference_id
    def initialize(attrs)
      self.bridge = attrs[:bridge]
      self.conference_id = attrs[:conference_id]
    end


    def make_call(number, options = {})
      options[:conference_id] ||= conference_id || bridge && bridge.conference_id
      options[:number] = Util.format_phone_number(number)
      result = Api.request('LCM', 'makeCall', options)
      # Not sure what to expect here...
    end

  end
end
