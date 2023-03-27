require 'cgi'

module Signbank
  class SignMenu
    HANDSHAPES = [
      [
        ['1.1.1', '1.1.2', '1.1.3'].freeze,
        ['1.2.1', '1.2.2'].freeze,
        ['1.3.1', '1.3.2'].freeze,
        ['1.4.1'].freeze
      ].freeze,
      [
        ['2.1.1', '2.1.2'].freeze,
        ['2.2.1', '2.2.2'].freeze,
        ['2.3.1', '2.3.2', '2.3.3'].freeze,
        ['8.1.1', '8.1.2', '8.1.3'].freeze
      ].freeze,
      [
        ['3.1.1'].freeze,
        ['3.2.1'].freeze,
        ['3.3.1'].freeze,
        ['3.4.1', '3.4.2'].freeze,
        ['3.5.1', '3.5.2'].freeze
      ].freeze,
      [
        ['4.1.1', '4.1.2'].freeze,
        ['4.2.1', '4.2.2'].freeze,
        ['4.3.1', '4.3.2'].freeze
      ].freeze,
      [
        ['5.1.1', '5.1.2'].freeze,
        ['5.2.1'].freeze,
        ['5.3.1', '5.3.2'].freeze,
        ['5.4.1'].freeze
      ].freeze,
      [
        ['6.1.1', '6.1.2', '6.1.3', '6.1.4'].freeze,
        ['6.2.1', '6.2.2', '6.2.3', '6.2.4'].freeze,
        ['6.3.1', '6.3.2'].freeze,
        ['6.4.1', '6.4.2'].freeze,
        ['6.5.1', '6.5.2'].freeze,
        ['6.6.1', '6.6.2'].freeze
      ].freeze,
      [
        ['7.1.1', '7.1.2', '7.1.3', '7.1.4'].freeze,
        ['7.2.1'].freeze,
        ['7.3.1', '7.3.2', '7.3.3'].freeze,
        ['7.4.1', '7.4.2'].freeze
      ].freeze
    ].freeze

    LOCATIONS = [
      ['1.1.In front of body', '2.2.In front of face'].freeze,
      ['3.3.Head', '3.4.Top of Head', '3.5.Eyes', '3.6.Nose', '3.7.Ear', '3.8.Cheek', '3.9.Lower Head'].freeze,
      [
        '4.0.Body',
        '4.10.Neck/Throat',
        '4.11.Shoulders',
        '4.12.Chest',
        '4.13.Abdomen',
        '4.14.Hips/Pelvis/Groin',
        '4.15.Upper Leg'
      ].freeze,
      ['5.0.Arm', '5.16.Upper Arm', '5.17.Elbow', '5.18.Lower Arm'].freeze,
      ['6.0.Hand', '6.19.Wrist', '6.20.Fingers/Thumb', '6.21.Palm of Hand', '6.22.Back of Hand', '6.23.Blades of Hand'].freeze
    ].freeze

    LOCATION_GROUPS = [
      '1.1.In front of body',
      '2.2.In front of face',
      '3.3.Head',
      '4.0.Body',
      '5.0.Arm',
      '6.0.Hand'
    ].freeze

    def self.handshapes
      HANDSHAPES
    end

    def self.locations
      LOCATIONS
    end

    def self.location_groups
      LOCATION_GROUPS
    end

    def self.usage_tags
      Sign.distinct.pluck(:usage, :usage).sort
    end

    def self.topic_tags
      Topic.pluck(:name, :name).sort.map { |tag| [tag.first, tag.second] }
    end
  end
end
