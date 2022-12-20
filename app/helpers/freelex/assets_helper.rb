module Freelex
  module AssetsHelper
    def freelex_asset_url(filename: '', high_res: false)
      filename = filename.gsub(/default.png$/i, 'high_resolution.png') if high_res
      File.join(ASSET_URL, filename)
    end
  end
end
