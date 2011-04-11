module StaticPagesHelper
  
  def alphabet_listing
    base = ("A".."Z").to_a
    #Replace P with P_open, P_closed
    p_index = base.index("P")
    base.delete_at(p_index)
    base.insert(p_index, "P_open", "P_closed")
    
    c_index = base.index("C")
    base.delete_at(c_index)
    base.insert(c_index, "C_half", "C_full")
    
    b_index = base.index("B")
    base.delete_at(b_index)
    base.insert(b_index, "B_open", "B_closed")
  end
  
  
  def classifiers
    return {
      :sass => {
        'SASS: spot-on-face' => classifier_image('SASS.spot_on_face'),
        'SASS: square-shape' => classifier_image('SASS.square_shape'),
        'SASS: square-frame-edge' => classifier_image('SASS.square_frame_edge'),
        'SASS: square-container' => classifier_image('SASS.square_container'),
        'SASS: thick' => classifier_image('SASS.thick'),
        'SASS: rake or claw' => classifier_image('SASS.rake_or_claw'),
        'SASS: thin-round-length (e.g. stick, cane)' => classifier_image('SASS.thin_round_length'),
        'SASS: thick-round-length (e.g. pole)' => classifier_image('SASS.thick_round_length'),
        'SASS: very-thick-round (e.g. trunk, pillar)' => classifier_image('SASS.very_thick_round')
      },
      :texture_consistency => {
        'Tactile: sandy' => classifier_image('texture_consistency_quality.tactile.sandy'),
        'Tactile: sticky' => classifier_image('texture_consistency_quality.tactile.sticky'),
        'Tactile: wet' => classifier_image('texture_consistency_quality.tactile.wet'),
        'Visual: bright' => classifier_image('texture_consistency_quality.visual.bright'),
        'Visual: twinkly' => classifier_image('texture_consistency_quality.visual.twinkly'),
        'Visual: sunshine' => classifier_image('texture_consistency_quality.visual.sunshine')
      },
      :entity => {
        :vehicle => {
          'Vehicle: into-garage' => classifier_image('entity.vehicle.into_garage'),
          'Vehicle: nose-to-tail-collision' => classifier_image('entity.vehicle.nose_to_tail_collision'),
          'Vehicle: reversing' => classifier_image('entity.vehicle.reversing'),
        },
        :person => {
          'Person: approach' => classifier_image('entity.person.approach'),
          'Persons: meet' => classifier_image('entity.persons.meet'),
          'Person: turn and walk away' => classifier_image('entity.person.turn_and_walk_away')
        },
        :two_legged => {
          'Legs: fall' => classifier_image('entity.legs.fall'),
          'Legs: jump' => classifier_image('entity.legs.jump'),
          'Legs: stand up' => classifier_image('entity.legs.stand_up')
        },
        :plane => {
          'Plane: plane-fly' => classifier_image('entity.plane.plane_fly'),
          'Plane: plane-take-off' => classifier_image('entity.plane.plane_take_off')
        }
      },
      :body_parts => {
        'Wings: flap' => classifier_image('body_parts.wings.flap'),
        'Neck + Head: whiplash' => classifier_image('body_parts.neck_and_head.whiplash'),
        'Claw' => classifier_image('body_parts.claw'),
        'Wide beak: open/shut (e.g. duck, goose)' => classifier_image('body_parts.wide-beak_open_shut')
      },
      :mass_or_quantity => {
        'Stuff: heap/pile' => classifier_image('mass_or_quantity.stuff.heap_pile'),
        'Persons: line' => classifier_image('mass_or_quantity.persons.line'),
        'Vehicles: heavy traffic' => classifier_image('mass_or_quantity.vehicles.heavy_traffic')
      },
      :handling_or_instrumental => {
        'Instrumental: computer-mouse' => classifier_image('handling_or_instrumental.computer_mouse'),
        'Instrumental: game-remote' => classifier_image('handling_or_instrumental.game_remote'),
        'Instrumental: bat' => classifier_image('handling_or_instrumental.bat'),
        'Instrumental: cricket-ball' => classifier_image('handling_or_instrumental.cricket_ball'),
        'Instrumental: softball' => classifier_image('handling_or_instrumental.softball'),
        'Instrumental: basketball' => classifier_image('handling_or_instrumental.basketball')
      },
      :element => {
        :fire => {
          'Element: candle-flame' => classifier_image('element.fire.candle_flame'),
          'Element: small-fire' => classifier_image('element.fire.small_fire'),
          'Element: bonfire' => classifier_image('element.first.bonfire')
        },
        :water => {
          'Element: water-drip' => classifier_image('element.water.water_drip'),
          'Element: flowing-water' => classifier_image('element.water.flowing_water'),
          'Element: water-flooding' => classifier_image('element.water.water_flooding'),
          'Element: water-overflowing' => classifier_image('element.water.water_overflowing')
        },
        :air => {
          'Element: gentle breeze' => classifier_image('element.air.gentle_breeze'),
          'Element: strong wind' => classifier_image('element.air.strong_wind'),
        }
      }
    }
  end
  
  private 
  def classifier_image(partial_image_identifier)
    return "/images/classifiers/Classifiers.#{partial_image_identifier}.png"
  end
end  
