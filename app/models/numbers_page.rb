##
# This data class categorises signs that are used for numbering in a number of contexts.
# It hardcodes sign IDs since these are stable references to the correct word, and there
# isn't a single categorisation that can be queried to fetch the correct data.
class NumbersPage
  CARDINAL_NUMBER_SIGN_IDS = %w[
    5655 4056 5607 5617 5619 5665 5688 5620 5621 5622 5623 5691 5624 5692 5694
    5693 5696 5697 5695 4065 5653 5608 2335 2741 2865 5609 5610 5570 5652 5611
    5612 5613 5614 5698 5615 5699 5700 5702 5701 5616 5618 5703 5704 5705 5715
    5716 5717 5718 5719 5720 6221 5706 5707 5708 5711 5712 5713 5730 5714 386
    5709 5710 2290 6237 6238 6239 6240 1109 4086
  ].freeze

  ORDINAL_NUMBER_SIGN_IDS = %w[
    5663 5438 5689
  ].freeze

  AGE_NUMBER_SIGN_IDS = %w[2099].freeze

  TIME_NUMBER_SIGN_IDS = %w[5425 5662 787 791 788 6230 6229].freeze

  MONEY_NUMBER_SIGN_IDS = %w[6233 6234].freeze

  FRACTIONAL_NUMBER_SIGN_IDS = %w[6235 6232 6236].freeze

  def cardinal_numbers
    category_signs(CARDINAL_NUMBER_SIGN_IDS)
  end

  def ordinal_numbers
    category_signs(ORDINAL_NUMBER_SIGN_IDS)
  end

  def age_numbers
    category_signs(AGE_NUMBER_SIGN_IDS)
  end

  def time_numbers
    category_signs(TIME_NUMBER_SIGN_IDS)
  end

  def money_numbers
    category_signs(MONEY_NUMBER_SIGN_IDS)
  end

  def fractional_numbers
    category_signs(FRACTIONAL_NUMBER_SIGN_IDS)
  end

  private

  def category_signs(sign_ids_in_category)
    Signbank::Sign.where(id: sign_ids_in_category).sort_by { |sign| sign_ids_in_category.index(sign.id) }
  end
end
