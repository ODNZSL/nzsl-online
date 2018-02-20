# frozen_string_literal: true

String.class_eval do
  def to_bool
    # ActiveRecord::ConnectionAdapters::Column.value_to_boolean(self)
    ActiveRecord::Type::Boolean.new.type_cast_from_database(self)
  end
end
