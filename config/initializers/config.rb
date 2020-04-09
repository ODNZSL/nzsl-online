# frozen_string_literal: true

SIGN_URL         = ENV.fetch('FREELEX_SIGN_URL', 'http://nzsl-assets.vuw.ac.nz/dnzsl/freelex/publicsearch')
AUTOCOMPLETE_URL = ENV.fetch('FREELEX_AUTOCOMPLETE_URL', 'http://nzsl-assets.vuw.ac.nz/dnzsl/ncbin/public_search_lookup')
ADMIN_EMAIL      = ENV.fetch('ADMIN_EMAIL', 'micky.vale@vuw.ac.nz')

ASSET_URL = ENV.fetch('ASSET_URL', 'http://nzsl-assets.vuw.ac.nz/dnzsl/freelex/assets/')

##
# Heroku enforces a 30 second timeout on our generating a response. We set a
# timeout for Freelex that allows us time to process the response and return it
# to our client within that constraint.
#
# This timeout option specifies when how long we should wait (in seconds) for
# data to be available to be read from the socket.
#
FREELEX_TIMEOUT = 20 # seconds
