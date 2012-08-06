require 'faraday'
require 'json'

module TurboBridge
  class Api
    class Error < TurboBridge::Error
      attr_accessor :code
      def initialize(code, msg)
        self.code = code
        super("#{code}: #{msg}")
      end
    end

    class << self
      def connection
        @connection || configure_connection
      end

      def configure_connection
        @connection = Faraday.new(url: Config.api_url) do |faraday|
          faraday.adapter Faraday.default_adapter
          faraday.headers['Content-Type'] = 'application/json'
          yield faraday if block_given?
        end
      end

      def request(method, cls, params)
        request = { request: {
            outputFormat: 'json',
            authAccount: translate_keys_outgoing(auth_details),
            requestList: [
                {
                    id: '1',
                    "#{method}#{cls}" + (method == 'get' ? 's' : '') => translate_keys_outgoing(params)
                }
            ]
        }}
        response = connection.post do |req|
          req.url "#{cls}"
          req.body = JSON.dump(request) #.tap {|s| puts s}
        end
        raise Error.new(response.status, response.body) unless response.status == 200
        response = JSON.parse(response.body)
        raise Error.new(response['error']['code'], response['error']['message']) if response['error']
        response = response["responseList"]["requestItem"][0]["result"]
        raise Error.new(response['error']['code'], response['error']['message']) if response['error']
        translate_keys_incoming(response) #.tap {|h| puts h.inspect}
      end

      private
      def auth_details
        Hash[[:partner_id, :account_id, :email, :password].map do |k|
          [k, Config.send(k)]
        end]
      end

      def translate_keys_outgoing(hsh)
        deep_translate(hsh) do |k,v|
          [k.to_s.gsub(/_id/, "ID").gsub(/_([a-z])/) {$1.capitalize}, v]
        end
      end

      def translate_keys_incoming(hsh)
        deep_translate(hsh) do |k,v|
          [k.to_s.gsub(/([A-Z]+)/) {"_#{$1}".downcase}, translate_keys_incoming(v)]
        end
      end

      def deep_translate(obj, &block)
        if obj.is_a? Hash
          Hash[obj.map(&block)]
        elsif obj.is_a? Array
          obj.map {|v| deep_translate(v, &block)}
        else
          obj
        end
      end
    end
  end
end