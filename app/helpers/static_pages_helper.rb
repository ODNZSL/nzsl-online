module StaticPagesHelper
  
  def alphabet_listing
    %w(A B_open B_closed C_half C_full D E F G H I J K L M N O P_open P_closed Q R S T U V W X Y Z)
  end
  
  def numbers_listing
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
  
  def ordinal_numbers_listing
   [['first', 5663],
    ['first', 2412],
    ['second', 2416],
    ['fourth', 2418],
    ['fifth', 2419]]
  end
  
  def fractions_listing
   [['1/2', nil ],
    ['1/3', 6232],
    ['1/4', nil ]]
  end
  
  def time_listing
   [['one o\'clock', 5662]]
  end
  
  def signs_from_array(array)
    array.map{|v| [v[0], Sign.find(:id => v[1])]}.reject{|v| v[1].nil? }
  end
  def link_sign name, id
    return link_to name, sign_path(id) if Sign.find(:id => id)
    return name
  end
  def classifiers
    {
      :sass => [
        ['spot on face', classifier_image('SASS.spot_on_face')],
        ['square shape', classifier_image('SASS.square_shape')],
        ['square frame edge', classifier_image('SASS.square_frame_edge')],
        ['square container', classifier_image('SASS.square_container')],
        ['thick', classifier_image('SASS.thick')],
        ['rake or claw', classifier_image('SASS.rake_or_claw')],
        ['thin round length (e.g. stick, cane)', classifier_image('SASS.thin_round_length')],
        ['thick round length (e.g. pole)', classifier_image('SASS.thick_round_length')],
        ['very thick and round (e.g. trunk, pillar)', classifier_image('SASS.very_thick_round')]
      ],
      :texture_consistency => [
        ['sandy', classifier_image('texture_consistency_quality.tactile.sandy')],
        ['sticky', classifier_image('texture_consistency_quality.tactile.sticky')],
        ['wet', classifier_image('texture_consistency_quality.tactile.wet')],
        ['bright', classifier_image('texture_consistency_quality.visual.bright')],
        ['twinkly', classifier_image('texture_consistency_quality.visual.twinkly')],
        ['sunshine', classifier_image('texture_consistency_quality.visual.sunshine')]
      ],
      :entity => [
        ['vehicle', [
          ['into garage', classifier_image('entity.vehicle.into_garage')],
          ['nose-to-tail collision', classifier_image('entity.vehicle.nose_to_tail_collision')],
          ['reversing', classifier_image('entity.vehicle.reversing')]
        ]],
        ['person', [
          ['approach', classifier_image('entity.person.approach')],
          ['meet', classifier_image('entity.persons.meet')],
          ['turn and walk away', classifier_image('entity.person.turn_and_walk_away')]
        ]],
        ['two legged', [
          ['fall', classifier_image('entity.legs.fall')],
          ['jump', classifier_image('entity.legs.jump')],
          ['stand up', classifier_image('entity.legs.stand_up')]
        ]],
        ['plane', [
          ['plane fly', classifier_image('entity.plane.plane_fly')],
          ['plane take-off', classifier_image('entity.plane.plane_take_off')]
        ]]
      ],
      :body_parts => [
        ['flap wings', classifier_image('body_parts.wings.flap')],
        ['whiplash', classifier_image('body_parts.neck_and_head.whiplash')],
        ['Claw', classifier_image('body_parts.claw')],
        ['open/shut beak (e.g. duck, goose)', classifier_image('body_parts.wide_beak_open_shut')]
      ],
      :mass_or_quantity => [
        ['pile of stuff', classifier_image('mass_or_quantity.stuff.heap_pile')],
        ['line of people', classifier_image('mass_or_quantity.persons.line')],
        ['heavy traffic', classifier_image('mass_or_quantity.vehicles.heavy_traffic')]
      ],
      :handling_or_instrumental => [
        ['computer-mouse', classifier_image('handling_or_instrumental.computer_mouse')],
        ['game-remote', classifier_image('handling_or_instrumental.game_remote')],
        ['bat', classifier_image('handling_or_instrumental.bat')],
        ['holding cricket-ball', classifier_image('handling_or_instrumental.holding_objects.cricket_ball')],
        ['holding softball', classifier_image('handling_or_instrumental.holding_objects.softball')],
        ['holding basketball', classifier_image('handling_or_instrumental.holding_objects.basketball')]
      ],
      :element => [
        ['Fire', [
          ['candle-flame', classifier_image('element.fire.candle_flame')],
          ['small-fire', classifier_image('element.fire.small_fire')],
          ['bonfire', classifier_image('element.fire.bonfire')]
        ]],
        ['Water', [
          ['water-drip', classifier_image('element.water.water_drip')],
          ['flowing-water', classifier_image('element.water.flowing_water')],
          ['water-flooding', classifier_image('element.water.water_flooding')],
          ['water-overflowing', classifier_image('element.water.water_overflowing')]
        ]],
        ['Air', [
          ['gentle breeze', classifier_image('element.air.gentle_breeze')],
          ['strong wind', classifier_image('element.air.strong_wind')],
        ]]
      ]
    }
  end
  
  private 
  def classifier_image(partial_image_identifier)
    return "/images/classifiers/90/Classifiers.#{partial_image_identifier}.png"
  end
end  
