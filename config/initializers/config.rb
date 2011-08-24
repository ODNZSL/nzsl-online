SIGN_URL         = 'http://freelex.nzsl.vuw.ac.nz/dnzsl/freelex/publicsearch'
ASSET_URL        = 'http://freelex.nzsl.vuw.ac.nz/dnzsl/freelex/assets/'
AUTOCOMPLETE_URL = 'http://freelex.nzsl.vuw.ac.nz/dnzsl/ncbin/public_search_lookup'
ADMIN_EMAIL = "david.mckee@vuw.ac.nz"

Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?


