require 'rails_helper'

RSpec.describe PagesHelper, type: :helper do
  let(:page) do
    FactoryGirl.build(
      :page,
      page_parts: FactoryGirl.build_stubbed_list(:page_part, 1)
    )
  end

  describe '#all_sources_present?' do
    subject { helper.all_sources_present?(page) }

    context 'all sources are present' do
      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'source missing' do
      before do
        allow_any_instance_of(PagePart)
          .to receive(:translation_path)
          .and_return('')
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
