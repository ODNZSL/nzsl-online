xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml << (render :partial => 'static_pages', locals: { slugs: @page_slugs })
  xml << (render :partial => 'signs', locals: { sign_ids: @sign_ids })

end