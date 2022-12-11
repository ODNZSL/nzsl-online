require 'rails_helper'

RSpec.describe 'Signbank: Sign features', type: :feature, sign_model_adapter: :freelex do
  it 'can search for signs'
  it 'can view a sign'
  it "can see a 'sign of the day'"
  it 'can request a random sign'
  it 'can add signbank signs to a vocab sheet'
end
