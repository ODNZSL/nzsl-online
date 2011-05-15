module NumbersHelper
  def numbers
    {:cardinal => signs_from_array(cardinal_array),
     :ordinal  => signs_from_array(ordinal_array),
     :fractions => signs_from_array(fractions_array),
     :clock => signs_from_array(clock_array),
     :calendar => signs_from_array(calendar_array),
     :age => signs_from_array(age_array),
     :money => signs_from_array(money_array)
    }
  end
private
  def cardinal_array
   [[0, 4056],
    [1, 5607],
    [2, 5617],
    [3, 5619],
    [4, 5620],
    [5, 5621],
    [6, 5622],
    [7, 5623],
    [9, 5696],
    [10, 4065],
    [11, 5608],
    [12, 5609],
    [13, 5610],
    [14, 5611],
    [15, 5612],
    [16, 5613],
    [18, 5615],
    [19, 5701],
    [20, 5618],
    [21, 5703],
    [22, 5704],
    [24, 5715],
    [25, nil ],
    [30, nil ],
    [40, 5707],
    [50, 5708],
    [60, 5711],
    [70, 5712],
    [80, 5713],
    [90, nil ],
    [100, 386],
    [100, 5709],
    [1000, 2290],
    [1000000, 1109],
    [1000000000, 4086]]
  end

  def ordinal_array
   [['first', 5663],
    ['first', 2412],
    ['second', 2416],
    ['fourth', 2418],
    ['fifth', 2419]]
  end

  def fractions_array
   [['1/2', nil ],
    ['1/3', 6232],
    ['1/4', nil ]]
  end

  def clock_array
   [['one o\'clock', 5662]]
  end
  
  def calendar_array
    []
  end
  def age_array
    []
  end
  
  def money_array
    []
  end
  def signs_from_array(array)
    array.map{|v| [v[0], Sign.find(:id => v[1])]}.reject{|v| v[1].nil? }
  end
end