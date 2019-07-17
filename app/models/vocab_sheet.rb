# frozen_string_literal: true

##
# A "sheet" of items (signs) saved by a user
#
class VocabSheet < ApplicationRecord
  ##
  # @param item [Item] The item you wish to add
  # @return [Boolean] true on success, false on failure
  #
  def add_item(item)
    # Don't add duplicates
    return true if raw_item_attrs.any? { |raw_item| raw_item['id'] == item.id }

    raw_item_attrs << convert_to_storable_hash(item)
    save
  end

  ##
  # @param item_attrs [Hash<String, Object>] The item attributes
  #
  # @return [Item, nil] Returns the updated item on success, otherwise nil
  #
  def update_item(item_attrs)
    # #find will return a reference to, not a copy of, a Hash object in the
    # `raw_item_attrs` Array. This means any changes we make to `item`
    # will be also be made to the object within `raw_item_attrs`.
    item = raw_item_attrs.find { |raw_item| raw_item['id'] == item_attrs['id'] }

    Item::UPDATABLE_ATTRIBUTES.each do |attr|
      item[attr] = item_attrs[attr] if item_attrs[attr]
    end

    save

    Item.new(item)
  end

  ##
  # @return [Array<Item>] array of items
  #
  def items
    raw_item_attrs.map { |item_attrs| Item.new(item_attrs) }
  end

  ##
  # @param item_id [String] The id of the item we should destroy
  # @return [Item, nil] - return the Item we destroyed on success or nil on failure
  #
  def destroy_item(item_id)
    return nil if item_id.nil?

    item = find_item_by(id: item_id)
    return nil if item.nil?

    # Remove the item from the Array of Hash objects
    raw_item_attrs.reject! { |raw_item| raw_item['id'] == item_id }

    # Removing the item does not automatically save (that is a bit of magic
    # that ActiveRecord implements for its relations) so we explicitly save the
    # whole VocabSheet.
    save

    item
  end

  ##
  # @param item_ids [Array<String>] The item ids in their desired (new) ordering
  # @return [nil] Return nil in all cases
  #
  def reorder_items(item_ids: [])
    return nil unless item_ids.is_a?(Array)

    new_raw_items = []

    item_ids.each do |id|
      new_raw_items << raw_item_attrs.find { |item| item['id'] == id }
    end

    self.raw_item_attrs = new_raw_items
    save

    nil
  end

  ##
  # @param sign_id [String] The sign id
  # @return [Boolean] Return true on success, false otherwise
  #
  def includes_sign?(sign_id)
    raw_item_attrs.any? { |item| item['sign_id'] == sign_id }
  end

  def self.purge_old_sheets
    max_days = 15
    VocabSheet.where('updated_at < ?', max_days.days.ago).destroy_all
  end

  private

  def find_item_by(id:)
    item_attrs = raw_item_attrs.find { |raw_item| raw_item['id'] == id }

    return nil if item_attrs.nil?

    Item.new(item_attrs)
  end

  def convert_to_storable_hash(item)
    item.as_json.except('errors', 'validation_context')
  end
end
