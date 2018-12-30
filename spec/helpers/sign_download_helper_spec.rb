# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignsHelper, type: :helper do
  drawing_1 = '1234/test01-1234-default.png' # rubocop:disable Naming/VariableNumber
  drawing_2 = '1234/test02-1234.png' # rubocop:disable Naming/VariableNumber
  drawing_3 = '1234/test03-default-1234-default.png' # rubocop:disable Naming/VariableNumber
  drawing_4 = '1234/test04-default-1234-DEfault.png' # rubocop:disable Naming/VariableNumber
  drawing_5 = '1234/test05-default-1234-DEFAULT.PNG' # rubocop:disable Naming/VariableNumber

  describe '#convert_to_high_resolution' do
    context 'when provided with a "default.png" sign drawing' do
      it 'returns the sign drawing with the text "high_resolution" as part of the file name' do
        expect(helper.convert_to_high_resolution(drawing_1)).to include('high_resolution.png')
      end
    end

    context 'when not provided with a "default.png" sign drawing' do
      it 'returns the sign drawing with the text "test02-1234" as part of the file name' do
        expect(helper.convert_to_high_resolution(drawing_2)).to include('test02-1234.png')
      end
    end

    context 'when provided with a "default.png" sign drawing and the string "default" as part of the drawing name' do
      it 'returns the sign drawing with the text "default-1234-high_resolution" as part of the file name' do
        expect(helper.convert_to_high_resolution(drawing_3)).to include('default-1234-high_resolution.png')
      end
    end

    context 'when provided with a mixed case "default.png" sign drawing' do
      it 'returns the sign drawing with the text "high_resolution" as part of the file name' do
        expect(helper.convert_to_high_resolution(drawing_4)).to include('high_resolution.png')
      end
    end

    context 'when provided with an upper case "default.png" sign drawing' do
      it 'returns the sign drawing with the text "high_resolution" as part of the file name' do
        expect(helper.convert_to_high_resolution(drawing_5)).to include('high_resolution.png')
      end
    end
  end
end
