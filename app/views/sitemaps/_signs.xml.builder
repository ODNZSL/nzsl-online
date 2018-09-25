sign_ids.each do |sign_id|
  xml.tag! 'url' do
    xml.tag! 'loc', sign_url(sign_id)
  end
end