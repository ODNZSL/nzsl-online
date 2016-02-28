NZSL_ADMIN_ACCESS = {} unless NZSL_ADMIN_ACCESS
module SpecHelpers
  module AuthHelper
    def basic_auth(user, password)
      credentials = ActionController::HttpAuthentication::Basic.encode_credentials user, password
      request.env['HTTP_AUTHORIZATION'] = credentials
    end
  end
end
