##
# This class bridges common operations where the correct class cannot
# be inferred directly (e.g. not within a model)
class SignModel
  def self.resolve
    Freelex::Sign
  end
end
