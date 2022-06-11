module Auth
  class Request
    def initialize(**args)
      @timestamp = args[:timestamp]
      @body = args[:body]
      @signature = args[:signature]
    end

    def call
      base_string = ['v0', @timestamp, @body].join(':')
      signed_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV.fetch('SLACK_APP_SECRET'), base_string)
      validation_string = ['v0=', signed_signature].join

      if validation_string == @signature
        {
          success: true
        }
      else
        {
          success: false
        }
      end
    end
  end
end