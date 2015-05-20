require 'hashie'

module TurboBridge
  class Cdr

    @@suffix = "CDR"

    module Error
      class CdrNotFound < TurboBridge::Error; end
    end

    # create an object for every result
    # looks like its sorted by date by default
    def self.where(params={})
      Api.request(@@suffix, 'getConferenceCDR', params)["conference_cdr"].map { |found|
        new(found)
      }
    rescue
      []
    end

    # expect just one result
    def self.find(cdr_id)
      found = Api.request(@@suffix, 'getConferenceCDR', cdr_id: cdr_id)
      raise Error::CdrNotFound unless found["total_results"] == 1
      new(found["conference_cdr"].first)
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