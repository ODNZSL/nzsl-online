$(function(){
  
  var video_control = function(control){
    var player = flowplayer($(control).first().closest('.controls').prev()[0])
    var action = $(control).attr('class')
    console.log(action)
    if (action == 'play'){
      player.play();
      $(control).hide().next().show();
    } else if (action == 'pause') {
      player.pause();
      $(control).hide().prev().show();
    }
  }
  if ($('a.video_replace')){
    flowplayer('a.video_replace', '/flowplayer-3.2.7.swf', {
      clip: {
        autoPlay: false,
        autoBuffering: false
      }, 
      plugins: {
        controls: {
          height:20,
          opacity:0.95,
          volume:false,
          mute:false,
          time:false,
          stop:false,
          fastForward:false,
          slowForward:false,
          scrubber:true,
          progressColor:'rgba(0,0,0,0.01)',
          sliderColor:'rgba(0,0,0,0.01)',
          durationColor:'rgba(0,0,0,0.01)',
          bufferColor:'rgba(0,0,0,0.01)', 
          backgroundColor:'#ffffff',
          backgroundGradient: [1,0],
          buttonColor:'#34414b',
          buttonOverColor: '#6c6f94',
          backgroundGradient:'medium',
          autoHide:'never'
        }
      },
      play: {
        replayLabel: null
      }
    })
  }
  //handle search menus
  
  // switch tabs
  $('.tab').click(function(){
    var tab = this.className.match(/(advanced|keywords|signs)/)[0];
    $('.tab, .search_form').removeClass('selected');
    $(this).addClass('selected');
    $('.search_form.'+tab).addClass('selected');
  });
  
  // show dropdown
  $('.sign_attribute_selection').click(function(e){
  
    e.stopPropagation();
    var hideOrShow = $(this).find('.dropdown').css('display') == 'none';
    $('.dropdown').hide();
    $(this).find('.dropdown').toggle(hideOrShow);
  });
  // select sign attributes
  $('.attribute_options').find('.group, .sub, .image').each(function(){
    $(this).click(function(e){
      e.stopPropagation();
      select_sign_attribute(this);
      update_selected_signs($(this).closest('.sign_attribute_selection'));
    });
  });
  $(document).click(function(){
    $('.dropdown').hide();
    return true; //so bubbles back up;
  });
  var select_sign_attribute = function(sign){
    var wrapper;
    if ($(sign).hasClass('group')) {
      wrapper = $(sign);
    } else if (!$(sign).hasClass('main_image') && !$(sign).parents('li.group').hasClass('selected')){
      // clicking on a sub image when the parent is selected
      wrapper = $(sign).parents('li').first();
    } else {
      wrapper = $(sign).closest('li:not(.sub)');
    }
    wrapper.toggleClass('selected');
  }
  var update_selected_signs = function(container) {
    var selected_container = $('<div />', {'class':'selected_signs'});
    var selected_images = container.find('.selected:not(.group.selected .selected)').children('.image')
    selected_images.clone().appendTo(selected_container);
    container.find('.selected_signs').replaceWith(selected_container);
    //hide "Any" unless we've deselected everything.
    container.find('.default').toggle(selected_images.length == 0);
    process_images_for_input(container, selected_images)
  }
  var process_images_for_input = function(container, images){
    var has_groups = container.find('.selected_groups_field').length;
    var output = [];
    var output_group = [];
    $(images).each(function(){
      if (has_groups && $(this).hasClass('main_image')){
        output_group.push($(this).text());
      } else {
        output.push($(this).text());
      }
    });
    if (has_groups){
      container.find('.selected_groups_field').first().val(output_group.join(' '));
    }
    container.find('.selected_field').first().val(output.join(' '));
  }
  
  // reorder vocab sheet items
  $('ul#vocab_sheet').sortable({containment: 'parent', update: reorderVocabSheet})//.disableSelection();
  var reorderVocabSheet = function(event, ui) {
    new_order = [];
    $('ul#vocab_sheet .item_id').each(function() { new_order.push($(this).val()); });
    $.post('#{reorder_vocab_sheet_items_path}', {'items[]': new_order});
  };
  
});