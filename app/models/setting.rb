class Setting < ActiveRecord::Base
  
  def self.update_all(params)
    params.each do |k,v| 
      Setting.where(key: k).first_or_create.update_attributes(value: v)
    end
  end
  
  def self.get(key)
    setting = find_by_key(key.to_s)
    setting.value if setting
  end

end
