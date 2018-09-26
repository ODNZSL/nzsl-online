class SitemapService

  def self.all_sign_ids
    tag_ids.map{ |tag_id| get_sign_ids_for_tag(tag_id) }.flatten
  end

  private

  def self.tag_ids
    SignMenu.topic_tags.map{ |tag| tag[1] }
  end

  def self.get_sign_ids_for_tag(tag_id)
    Sign.all({ tag: tag_id }).map{ |sign| sign.id }
  end
end