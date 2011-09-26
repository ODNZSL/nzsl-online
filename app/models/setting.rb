class Setting < ActiveRecord::Base
  
  def self.update_all(params)
    params.each do |k,v| 
      Setting.find_or_create_by_key(k).update_attributes({:value => v})
    end
  end
  
  def self.get(key)
    setting = find_by_key(key.to_s)
    setting.value if setting
  end

end