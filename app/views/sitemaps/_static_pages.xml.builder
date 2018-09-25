slugs.each do |slug|
  xml.tag! 'url' do
    xml.tag! 'loc', slug
  end
end