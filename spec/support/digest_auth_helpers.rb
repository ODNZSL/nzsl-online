module SpecHelpers
  module DigestAuthHelpers
    def authenticate_with_http_digest(user, password, &request_trigger)
      request.env['HTTP_AUTHORIZATION'] = encode_credentials(user, password, &request_trigger)
      request_trigger.call
    end

    # Shamelessly stolen from the Rails 4 test framework.
    # See https://github.com/rails/rails/blob/a3b1105ada3da64acfa3843b164b14b734456a50/actionpack/test/controller/http_digest_authentication_test.rb
    def encode_credentials(user, password, &request_trigger)
      # Perform unauthenticated request to retrieve digest parameters to use on subsequent request
      request_trigger.call
      expect(response).to have_http_status(:unauthorized)

      credentials = decode_credentials(response.headers['WWW-Authenticate'])
      credentials.merge!(username: user, nc: '00000001', cnonce: '0a4f113b', password_is_ha1: false)
      path_info = request.env['PATH_INFO'].to_s
      credentials.merge!(uri: path_info)
      request.env['ORIGINAL_FULLPATH'] = path_info
      ActionController::HttpAuthentication::Digest.encode_credentials(request.method, credentials, password, credentials[:password_is_ha1])
    end

    # Also shamelessly stolen from the Rails 4 test framework.
    # See https://github.com/rails/rails/blob/a3b1105ada3da64acfa3843b164b14b734456a50/actionpack/test/controller/http_digest_authentication_test.rb
    def decode_credentials(header)
      ActionController::HttpAuthentication::Digest.decode_credentials(header)
    end
  end
end
