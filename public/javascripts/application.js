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
        controls: null
        //{
        //  height:20,
        //  opacity:0.95,
        //  volume:false,
        //  mute:false,
        //  time:false,
        //  stop:false,
        //  fastForward:false,
        //  slowForward:false,
        //  scrubber:false,
        //  progressColor:'rgba(0,0,0,0.01)',
        //  sliderColor:'rgba(0,0,0,0.01)',
        //  durationColor:'rgba(0,0,0,0.01)',
        //  bufferColor:'rgba(0,0,0,0.01)', 
        //  backgroundColor:'#ffffff',
        //  backgroundGradient: [1,0],
        //  buttonColor:'#34414b',
        //  buttonOverColor: '#6c6f94',
        //  backgroundGradient:'medium',
        //  autoHide:'never'
        //}
      },
      play: {
        replayLabel: null
      }
    });
    $('a.video_replace').click(function(e){
      e.preventDefault();
    });
  }
  //handle search menus
  $('.button.normal, .button.slow').click(function(){
    var show, hide;
    var videos = $(this).closest('.videos');
    if ($(this).hasClass('normal')){
      show = 'slow';
      hide = 'normal';
    } else {
      show = 'normal';
      hide = 'slow';
    }
    videos.find("."+show).show();
    videos.find("."+hide).hide();
    flowplayer(videos.find('.video_replace.'+hide)[0]).pause();
    flowplayer(videos.find('.video_replace.'+show)[0]).play();
  });
  // switch tabs
  $('.tab, .tab_link').click(function(e){
    e.preventDefault();
    var tab = this.className.match(/(advanced|keywords|signs)/)[0];
    $('.tab, .search_form').removeClass('selected');
    $('.tab.'+tab+', .search_form.'+tab).addClass('selected');
  });
  // show dropdown
  $(document).click(function(){
    hide_all_dropdowns();
    return true; //so bubbles back up;
  });
  
  var hide_all_dropdowns = function(){
    $('.dropdown').hide();
    $('.dropdown_arrow').removeClass('selected shadow');
  };
  
  $('.sign_attribute_selection').click(function(e){
    e.stopPropagation();
    e.preventDefault();
    var hideOrShow = $(this).find('.dropdown').css('display') == 'none';
    hide_all_dropdowns();
    $(this).find('.dropdown').toggle(hideOrShow);
    $(this).find('.dropdown_arrow').toggleClass('selected shadow', hideOrShow)
    return false;
  });
  
  // select sign attributes
  $('.attribute_options').find('.group, .sub, .image').each(function(){
    $(this).click(function(e){
      e.stopPropagation();
      select_sign_attribute(this);
      update_selected_signs($(this).closest('.sign_attribute_selection'));
    });
  });
  $('.empty').click(function(){
    var tab = $(this).closest('.search_form');
    tab.find('.selected_signs').empty();
    tab.find('.dropdown .selected').removeClass('selected')
    tab.find('.default, .input_prompt').show();
    tab.find('.selected_field, .selected_groups_field, .text_input').val(null);
    tab.find('select').select('');
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
    /* each of the images needs to be pointing to the smaller image. boom. */
    selected_container.find('img').each(function(){
      $(this).attr('src', $(this).attr('src').replace('/72/', '/42/'));
    });
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
  //sensible source-order, javascript-off-friendly placeholder labels.
  //overlays the label on the input on load. hides it on click/focus.
  //shows it if there's nothing in the field on blur.
  if ($('label.input_prompt').length){
    $('label.input_prompt').each(function(){
      var label = $(this)
      var input = $('#'+label.attr('for'));
      label.css({width:input.outerWidth()+'px',height:input.outerHeight()+'px',position:'absolute',zIndex:99,lineHeight:input.outerHeight()+'px'})
           .click(function(){
              label.hide();
           });
      input.focus(function(){ label.hide(); })
           .blur(function(){
             if (input.val() == ''){
                label.show();
             }
           });
    });
  }
  // reorder vocab sheet items
  if ($('ul#vocab_sheet').length){
    $('ul#vocab_sheet').sortable({containment: 'parent', update: reorderVocabSheet})//.disableSelection();
    var reorderVocabSheet = function(event, ui) {
      new_order = [];
      $('ul#vocab_sheet .item_id').each(function() { new_order.push($(this).val()); });
      $.post('#{reorder_vocab_sheet_items_path}', {'items[]': new_order});
    };
  }
  
});