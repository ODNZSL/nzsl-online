module PagesHelper
  def mp4_source(page)
    source_path(page) << '.mp4'
  end

  def webm_source(page)
    source_path(page) << '.webm'
  end

  def all_sources_present?(page)
    source_path(page, false).exclude?(nil)
  end

  private

  def source_path_components(page)
    {
      s3_bucket_url: Rails.application.secrets[:s3_bucket_url],
      translation_path: page.first_part.try(:translation_path)
    }
  end

  def source_path(page, join = true)
    return source_path_components(page).values.join if join
    source_path_components(page).values
  end
end
