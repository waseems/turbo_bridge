require 'hashie'

module TurboBridge
  class Cdr

    @@suffix = "CDR"

    module Error
      class CdrNotFound < TurboBridge::Error; end
      #class ConferenceAlreadyExists < TurboBridge::Error; end
    end

    def self.find(conference_id, start_begin=0, start_end=0)
      found = Api.request(@@suffix, 'getConferenceCDR', conference_id: conference_id, confStartBeginTimestamp: start_begin, confStartBeginTimestamp: start_end)
#      raise Error::CdrNotFound unless found["total_results"] == 1
#      new(found["cdr"][0])
    end

    def initialize(attrs)
      self.attributes = attrs
    end

    private
    def attributes=(attrs)
      # We are read-only, updates must be done via #update_attributes!
      @attributes = Hashie::Mash.new(attrs).freeze
    end

    def method_missing(m, *args)
      if args.length == 0
        # Attribute accessors
        @attributes.send(m)
      else
        super
      end
    end
  end
end