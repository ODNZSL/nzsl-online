require 'rails_helper'

RSpec.describe 'PagePart', type: :model do
  it { is_expected.to have_attribute :title }
  it { is_expected.to have_attribute :order }
  it { is_expected.to have_attribute :body }
  it { is_expected.to have_attribute :translation_path }
  it { is_expected.to have_attribute :page_id }

  let!(:page_part) { FactoryBot.build(:page_part) }

  subject { page_part }
end
