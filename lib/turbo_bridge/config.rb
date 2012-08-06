module TurboBridge
  class Config
    class << self
      attr_accessor :api_url, :account_id, :email, :password

      def api_url
        "https://turbobridge.com/api/2.0/"
      end

      def partner_id
        "turbobridge"
      end

      def merge(hsh)
        hsh.each do |k,v|
          send("#{k}=", v)
        end
      end
    end
  end
end