module NumbersHelper
  def numbers
    return @numbers if @numbers.present?
    @number_signs = {}
    Sign.all(tag: 29).each { |s| @number_signs[s.id.to_i] = s }
    @numbers = { cardinal:  signs_from_array(cardinal_array),
                 ordinal:   signs_from_array(ordinal_array),
                 fractions: signs_from_array(fractions_array),
                 time:      signs_from_array(time_array),
                 age:       signs_from_array(age_array),
                 money:     signs_from_array(money_array) }
  end

  private

  def cardinal_array # rubocop:disable Metrics/MethodLength
    [[0,  5655],     [0,  4056],
     [1,  5607],     [2,  5617],
     [3,  5619],     [3,  5665],
     [3,  5688],     [4,  5620],
     [5,  5621],     [6,  5622],
     [7,  5623],     [7,  5691],
     [7,  5690],     [8,  5624],
     [8,  5692],     [8,  5694],
     [8,  5693],     [9,  5696],
     [9,  5697],     [9,  5695],
     [10, 4065],     [10, 5653],
     [11, 5608],     [11, 2335],
     [11, 2741],     [12, 2865],
     [12, 5609],     [13, 5610],
     [13, 5570],     [13, 5652],
     [14, 5611],     [15, 5612],
     [16, 5613],     [17, 5614],
     [17, 5698],     [18, 5615],
     [18, 5699],     [18, 5700],
     [19, 5702],     [19, 5701],
     [19, 5616],     [20, 5618],
     [21, 5703],     [22, 5704],
     [23, 5705],     [24, 5715],
     [25, 5716],     [26, 5717],
     [27, 5718],     [28, 5719],
     [29, 5720],     [29, 6221],
     [30, 5706],     [40, 5707],
     [50, 5708],     [60, 5711],
     [70, 5712],     [80, 5713],
     [90, 5730],     [90, 5714],
     [100, 386],     [100, 5709],
     [100, 5710],
     ['1,000', 2290],
     ['10,000', 6237],
     ['100,000', 6238],
     ['100,000', 6239],
     ['100,000', 6240],
     ['1,000,000 (million)', 1109],
     ['1,000,000,000 (billion)', 4086]]
  end

  def ordinal_array
    [['first',  5663],
     ['second', 5438],
     ['third',  5689]]
  end

  def fractions_array
    [['1/2', 6235],
     ['1/3', 6232],
     ['1/4', 6236]]
  end

  def time_array
    [['one hour',     5425],
     ['one o\'clock', 5662],
     ['quarter (to / past the hour)', 787],
     ['quarter to',    791],
     ['quarter past',  788],
     ['half past', 6230],
     ['past (the hour)', 6229]]
  end

  def age_array
    [['one year old', 2099]]
  end

  def money_array
    [['one dollar', 6233],
     ['one dollar', 6234]]
  end

  def signs_from_array(array)
    array.map { |v| [v[0], @number_signs[v[1]]] }.reject { |v| v[1].nil? }
  end
end
