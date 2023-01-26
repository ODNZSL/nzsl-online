# frozen_string_literal: true

## Settings for the web app
class Setting < ApplicationRecord
  validates :key, :value, presence: true

  def self.update_all_settings(params)
    params.each do |k, v|
      Setting.where(key: k).first_or_create.update(value: v)
    end
  end

  def self.get(key)
    setting = find_by(key: key.to_s)
    setting&.value
  end

  def self.create_from_csv!(row)
    _id, key, value, created_at, updated_at = row
    setting = Setting.where(key:).first_or_initialize
    setting.update!(
      key:,
      value:,
      updated_at:,
      created_at:
    )
    setting
  end
end
