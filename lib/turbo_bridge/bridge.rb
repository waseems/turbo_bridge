require 'hashie'

module TurboBridge
  class Bridge
    module Error
      class BridgeNotFound < TurboBridge::Error; end
      class ConferenceAlreadyExists < TurboBridge::Error; end
    end

    def self.request(action, options = {})
      action ="#{action}Bridge" + (action == 'get' ? 's' : '')
      Api.request('Bridge', action, options)
    end

    def self.create!(attrs)
      begin
        new(Api.request('Bridge', 'setBridge', attrs.merge(editMode: 'createOnly'))["bridge"])
      rescue TurboBridge::Api::Error => err
        if err.code == 'ERR_API_DUPLICATE_CONFERENCEID'
          raise Error::ConferenceAlreadyExists
        else
          raise err
        end
      end
    end

    def self.find(conference_id)
      found = Api.request('Bridge', 'getBridges', conference_id: conference_id)
      raise Error::BridgeNotFound unless found["total_results"] == 1
      new(found["bridge"][0])
    end

    def initialize(attrs)
      self.attributes = attrs
    end

    def update_attributes!(attrs)
      begin
        self.attributes = Api.request('Bridge', 'setBridge', attrs.merge(conference_id: conference_id, editMode: 'modifyOnly'))["bridge"]
      rescue TurboBridge::Api::Error => err
        if err.code == 'ERR_API_CONFERENCEID_NOT_FOUND'
          raise Error::BridgeNotFound
        else
          raise err
        end
      end
      return self
    end

    def self.destroy!(conference_id)
      begin
        !!Api.request('Bridge', 'deleteBridge', conference_id: conference_id)
      rescue TurboBridge::Api::Error => err
        if err.code == 'ERR_API_CONFERENCEID_NOT_FOUND'
          raise Error::BridgeNotFound
        else
          raise err
        end
      end
    end

    def destroy!
      self.class.destroy!(conference_id)
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