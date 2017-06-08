## Settings for the web app
class Setting < ActiveRecord::Base
  validates :key, :value, presence: true

  def self.update_all(params)
    params.each do |k, v|
      Setting.where(key: k).first_or_create.update_attributes(value: v)
    end
  end

  def self.get(key)
    setting = find_by_key(key.to_s)
    setting.value if setting
  end

  def self.create_from_csv!(row)
    _id, key, value, created_at, updated_at = row
    setting = Setting.where(key: key).first_or_initialize
    setting.update!(
      key: key,
      value: value,
      updated_at: updated_at,
      created_at: created_at
    )
    setting
  end
end
