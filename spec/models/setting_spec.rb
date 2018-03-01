# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Setting', type: :model do
  subject { setting }

  let!(:setting) do
    FactoryBot.create(:setting)
  end

  it { is_expected.to have_attribute :key }
  it { is_expected.to have_attribute :value }




  describe '.update_all' do
    let(:params) do
      [
        %w(boo yikes),
        %w(blerg greeb),
        %w(help hydra),
        %w(flock mrrg)
      ]
    end

    it 'updates records in the db' do
      subject
      Setting.update_all(params)
      new_setting = Setting.find_by(key: setting.key)
      expect(new_setting.value).to eq 'hydra'
    end

    it 'creates new records where needed' do
      subject
      expect(Setting.all.length).to eq 1
      Setting.update_all(params)
      expect(Setting.all.length).to eq 4
    end
  end

  describe '.get' do
    let(:key) { setting.key }

    context 'when the setting is in the database' do
      it 'finds the setting by its key' do
        subject
        expect(Setting.get(key)).to eq setting.value
      end
    end

    context 'when the setting is not in the database' do
      let(:key) { 'random thing' }

      it 'returns nil' do
        subject
        expect(Setting.get(key)).to eq nil
      end
    end
  end

  describe '.create_from_csv!' do
    context 'when the setting exists in the database' do
      let(:row) { [23, 'help', '4.5.6', setting.created_at, setting.updated_at] }

      it 'updates the record' do
        subject
        Setting.create_from_csv!(row)
        updated_setting = Setting.find_by(key: setting.key)
        expect(updated_setting.value).to eq '4.5.6'
      end
    end

    context 'when the setting does not yet exist in the database' do
      let(:row) { [23, 'doorstop', '7.8.9', setting.created_at, setting.updated_at] }

      it 'creates the record' do
        subject
        expect(Setting.all.length).to eq 1
        Setting.create_from_csv!(row)
        expect(Setting.all.length).to eq 2
      end
    end
  end
end
