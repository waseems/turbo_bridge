# LiveManager implements the turbobridge LCM (live conference manager) API
module TurboBridge
  class LiveManager
    attr_accessor :bridge, :conference_id
    def initialize(attrs)
      self.bridge = attrs[:bridge]
      self.conference_id = attrs[:conference_id]
    end


    def make_call(number, options = {})
      my_options = options.dup # Unfreeze a frozen object
      my_options[:conference_id] = my_options[:conference_id] || conference_id || bridge && bridge.conference_id
      my_options[:number] = Util.format_phone_number(number)
      result = Api.request('LCM', 'makeCall', my_options)
      # Not sure what to expect here...
    end

  end
end
