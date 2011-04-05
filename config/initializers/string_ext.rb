String.class_eval do
  def to_bool
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(self)
  end
end

