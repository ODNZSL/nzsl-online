class AddPrivacyPageAndUpdateCopyright < ActiveRecord::Migration[8.1]
  def up
    Page.create!(
      title: 'Privacy notice',
      slug: 'privacy',
      label: 'Privacy notice',
      order: 14,
      template: 'standard',
      show_in_nav: true
    ) unless Page.exists?(slug: 'privacy')

    Page.where(slug: 'copyright').update_all(title: 'Copyright and license conditions - VUW NZSL Resources')
  end

  def down
  end
end
