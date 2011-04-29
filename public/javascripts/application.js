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
      },
      play: {
        replayLabel: null
      }// ,
      //       onFinish: showPlay,
      //       onStart: showPause
    })
    $('a.video_replace').after(
      $('<div />', {'class':'controls'}).append(
        $('<a />', {href:'javascript:void(0);', 'class':'play', text: 'Play'}),
        $('<a />', {href:'javascript:void(0);', 'class':'pause', text: 'Pause'}),
        $('<a />', {href:'javascript:void(0);', 'class':'slow', text: 'Play in Slow Motion'}),
        $('<a />', {href:'javascript:void(0);', 'class':'zoom', text: 'Play in full screen'})
      )
    );
    $('.controls a').click(function(){video_control(this)})
  }
  // TODO: delay closing by a second
  $('.sign_attribute_selection').click(function(e){
    e.stopPropagation();
    $('.dropdown').hide();
    $(this).find('.dropdown').show();
  });
  $('.sign_attribute_selection').hover(function(e){
    $('.dropdown').hide();
    $(this).find('.dropdown').show();
  }, function(){
    $('.dropdown').hide();
  });
  $('body').click(function(){
    $('.dropdown').hide();
  });
  //handle selecting signs
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
  $('.attribute_options').find('.group, .sub, .image').each(function(){
    $(this).click(function(e){
      e.stopPropagation();
      select_sign_attribute(this);
      update_selected_signs($(this).closest('.sign_attribute_selection'));
    });
  });
  $('.tab').click(function(){
    var tab = this.className.match(/(advanced|keywords|signs)/)[0];
    $('.tab, .search_form').removeClass('selected');
    $(this).addClass('selected');
    $('.search_form.'+tab).addClass('selected');
  });
});