##
# This class bridges common operations where the correct class cannot
# be inferred directly (e.g. not within a model)
class SignMenu
  class_attribute :adapter, default: ENV.fetch('SIGN_MODEL_ADAPTER', 'freelex')

  def self.resolve
    if freelex?
      Freelex::SignMenu
    elsif signbank?
      Signbank::SignMenu
    else
      raise ArgumentError, "Unexpected adapter: '#{adapter}'"
    end
  end

  def self.freelex?
    adapter == 'freelex'
  end

  def self. signbank?
    adapter == 'signbank'
  end
end
