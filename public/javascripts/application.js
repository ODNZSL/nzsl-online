$(function(){
  var use_video;
  var setup = function(){
    setup_ckeditor_video_links();
    setup_use_video();
    setup_videos();
    setup_slow_motion_videos();
    setup_help_videos();
    setup_search_tabs();
    setup_sign_selection();
    setup_handshapes_hover_fix();
    setup_prompt_labels();
    
    setup_print_view();
    
    setup_vocab_sheet_page();
    setup_vocab_remove();
    setup_add_to_sheet();
        
    setup_feedback_form();
    
    setup_keyword_autocomplete();
  }
  var setup_ckeditor_video_links = function(){
    var videos;
    //standard link (alphabet pages)
    if (videos = $(".ckeditor_content a").filter(':contains(-video-)')){
      videos.addClass('video_replace main_video').each(function(){
        var video = $(this);
        console.log(video)
        video.html(video.html().replace(/^\s*-video-\s*/, ''));
      }).not('li a').wrap($('<div />', {'class':'videos clearfix_left'}));
    }
    //list link
    var list;
    if (list = $('.ckeditor_content ul').has('.video_replace')){
      list.wrap($('<div />', {'class':'playlist'}));
      var video_bucket = $('<div />', {'class':'videos clearfix_left'})
      list.find('a').each(function(i){
        var link = $(this);
        var link_class = link.text().toLowerCase().replace(/[^a-z0-9]+/g, '-') + '-video'
        link.addClass(link_class);
        var video = link.clone();
        video.attr('id', link_class).addClass('hidden_video').empty().appendTo(video_bucket);
        if (i === 0){
          video.removeClass('hidden_video').addClass('selected')
          link.css({fontWeight:'bold'});
        }
        link.attr('href', 'javascript:void(0)').removeClass('video_replace main_video')
      });
      list.before(video_bucket);
    }
  }

  var setup_use_video = function(){
    use_video = navigator.userAgent.match(/iphone/i) && navigator.userAgent.match(/ipad/i)
  }
  var setup_videos = function(){
    var videos;
    if (videos = $('.video_replace')){
      videos.each(function(){
        var wrapper = $(this);
        var href = wrapper.attr('href');
        var hidden = wrapper.hasClass('hidden_video');
        if (window.location.hash == "#skipflash"){
          wrapper.empty()
                 .append($('<video />', {src: href,
                                         controls:"controls",
                                         autobuffer:(hidden ? undefined : "autobuffer")}))
        } else {
          if (hidden){
            wrapper.addClass('.video_replace_hidden_flash');
          } else {
            wrapper.addClass('.video_replace_flash');
          }
        }
      });
    }
    var hidePlay = function(){this.getPlugin('play').css({opacity:0})};
    var flowplayer_config = {
      key: '#$c1ee98f7e52a995b8d9',
      clip: {
        onFail: function(a,b,c){
          console.log(a,b,c);
        },
        autoPlay: false,
        autoBuffering: true,
        onFinish: hidePlay,
        onStart:  hidePlay
      },
      
      plugins: {
        play:{opacity:0},
        controls: {
          height:25,
          opacity:0.5,
          volume:false,
          mute:false,
          time:false,
          stop:false,
          fastForward:false,
          slowForward:false,
          scrubber:true,
          backgroundColor:'rgba(0,0,0,0)',
          backgroundGradient: [1,0],
          buttonColor:'#ffffff',
          buttonOverColor: '#ffffff',
          backgroundGradient:'none',
          autoHide:'never',
          
          tooltips:{
            buttons:true
          }
        }
      },
      play: {
        replayLabel: null
      }
    };
    var flowplayer_hidden_config = $.extend(true, {}, flowplayer_config)
    flowplayer_hidden_config.clip.autoBuffering = false;
    $f('.video_replace_hidden_flash', {src: '/flowplayer.commercial-3.2.7.swf' , wmode: 'transparent'}, flowplayer_hidden_config).each(function(){this.ipad()});
    $f('.video_replace_flash', {src: '/flowplayer.commercial-3.2.7.swf' , wmode: 'transparent'}, flowplayer_config).each(function(){this.ipad()});
    $('.video_replace').attr('href', 'javascript:void(0);');
  }
  var setup_slow_motion_videos = function(){
    $('.button.normal, .button.slow, .button.translation_button').click(function(){
      var show, hide, video;
      var videos = $(this).closest('.videos');
      if ($(this).hasClass('normal')){
        show = 'slow';
        hide = 'normal';
      } else if ($(this).hasClass('slow')) {
        show = 'normal';
        hide = 'slow';
      } else {
        show = 'translation_video';
        hide = 'translation_button';
      }
      videos.find("."+hide).hide();
      videos.find("."+show).show();
      play_video(show, videos);
      pause_video(hide, videos);
    });
  }
  var setup_help_videos = function(){
    var wrapper = $('.playlist');
    wrapper.find('ul a').click(function(e){
      var video_class = this.className;
      wrapper.find('ul a').css({fontWeight:'normal'});
      $(this).css({fontWeight:'bold'});
      var old_video = wrapper.find('.video_replace.selected')
      pause_video('selected', wrapper)
      old_video.hide().removeClass('selected');
      var new_video = wrapper.find('.video_replace.'+video_class)
      new_video.show().addClass('selected');
      play_video('selected', wrapper);
    });
  }
  var play_video = function(video_class, wrapper){
    var video, video_element;
    if (video = wrapper.find('.video_replace.'+video_class)[0]) {
      if (video_element = $(video).find('video, embed[type="video/divx"]')[0]){
        video_element.play();
      } else {
        console.log(video)
        flowplayer(video).play();
      }
    }
  }
  var pause_video = function(video_class, wrapper){
    var video, video_element;
    if (video = wrapper.find('.video_replace.'+video_class)[0]) {
      if (video_element = $(video).find('video, embed[type="video/divx"]')[0]){
        video_element.pause();
      } else {
        flowplayer(video).pause();
      }
    }
  }
  var reset_menu_position = function(){
    // this is insane.
    // IE7 was getting not updating the position of the menus when we show and hid search bars
    // so I'll do it manually. This forces it to redraw.
    var bottom = $('.menu').css('bottom')
    $('.menu').css('bottom', '0').css('bottom', bottom)
  }
  var setup_search_tabs = function(){
    $('.tab, .tab_link').click(function(e){
      e.preventDefault();
      var tab = this.className.match(/(advanced|keywords|signs)/)[0];
      $('.tab, .search_field').removeClass('selected');
      $('.tab.'+tab+', .search_field.'+tab).addClass('selected');
      reset_menu_position()
    });
  }
  var setup_sign_selection = function(){
    $(document).click(function(){
      hide_all_dropdowns();
      return true; //so bubbles back up;
    });
    
    $('.sign_attribute_selection').click(function(e){
      e.stopPropagation();
      e.preventDefault();
      
      var hideOrShow = $(this).find('.dropdown').css('display') == 'none';
      hide_all_dropdowns();
      $(this).find('.dropdown').toggle(hideOrShow);
      $(this).find('.dropdown_arrow').toggleClass('selected shadow', hideOrShow)
      if (hideOrShow) {
        //for IE7 and his layering issues
        $(this).closest('.sign_attribute_selection').css('zIndex', '100')
      }
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
    $('.search_form form').each(function(){
      toggle_clear(this)
    }).find('.text_input, .selected_field, .selected_groups_field')
      .change(function(){toggle_clear($(this).closest('form'))});
    
    $('.empty').click(function(){
      var tab = $(this).closest('.search_form');
      tab.find('.selected_signs').empty();
      tab.find('.dropdown .selected').removeClass('selected')
      tab.find('.default, .input_prompt').show();
      tab.find('.selected_field, .selected_groups_field, .text_input').val(null);
      tab.find('select').select('');
      tab.find('.empty').hide();
    });
  }
  
  var toggle_clear = function(form){
    var show = false;
    $(form).find('.text_input, .selected_field, .selected_groups_field').each(function(){
      if($(this).val()){
        show = true;
        return show;
      }
    });
    $(form).find('.empty').toggle(show)
  }
  
  var hide_all_dropdowns = function(){
    $('.dropdown').hide();
    $('.dropdown_arrow').removeClass('selected shadow');
    $('.sign_attribute_selection').css('zIndex', '30')
  };
  
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
    toggle_clear(container.closest('form'));
  }
  var setup_handshapes_hover_fix = function(){
    $('.attribute_options .row, .attribute_options .group, .attribute_options .sub').hover(function(){
      $(this).addClass('hover')
    }, function(){
      $(this).removeClass('hover')
    });
  }
  var setup_prompt_labels = function(){
    //sensible source-order, javascript-off-friendly placeholder labels.
    //overlays the label on the input on load. hides it on click/focus.
    //shows it if there's nothing in the field on blur.
    if ($('label.input_prompt').length){
      $('label.input_prompt').each(function(){
        var label = $(this)
        var input = $('#'+label.attr('for'));
        label.css({width:input.outerWidth()+'px',top:'0',left:'0',height:input.outerHeight()+'px',position:'absolute',zIndex:99,lineHeight:input.outerHeight()+'px'})
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
      reset_menu_position();
    }
  }
  var setup_print_view = function(){
    //load print
    if (document.printView) {
      $('textarea, input[type="text"]').attr('readonly', true)
      $(window).bind('load', function(){
        window.print();
      });
    }
  }
  var hide_vocab_bar_if_empty = function(){
    var bar = $('.vocab_sheet_bar');
    if (bar.length && bar.find('.vocab_sheet_bar_item').length === 0) {
      bar.hide();
      $('body').removeClass('vocab_sheet_background');
    }
  }
  var show_vocab_bar = function(){
    if ($('.vocab_sheet_bar').length){
      $('.vocab_sheet_bar').show();
      $('body').addClass('vocab_sheet_background');
    }
  }
  var setup_vocab_remove = function(){
    $('.remove').live('click', function(e){
      e.preventDefault();
      var button = $(this);
      var form = button.closest('form');
      $.post(form.attr('action'), form.serialize());
      button.closest('.vocab_sheet_item').animate({height:0}, 200, function(){
        $(this).remove();
        hide_vocab_bar_if_empty();
      });
      
    });
  }
  var setup_add_to_sheet = function(){
    $('.add_to_sheet').click(function(e){
      e.preventDefault();
      var button = $(this);
      var form = button.closest('form');
      $.post(form.attr('action'), form.serialize(), function(data){
        show_vocab_bar();
        $(data).appendTo($('.vocab_sheet_bar ul'));
      });
    });
  }
  var setup_vocab_sheet_page = function(){
    // reorder vocab sheet items
    if ($('ul#vocab_sheet').length){
      $('ul#vocab_sheet .button, .vocab_sheet_name .button').hide();
      if (!document.printView){
        $('ul#vocab_sheet').sortable({containment: 'parent', update: function(event, ui) {
          new_order = [];
          $('ul#vocab_sheet .item_id').each(function() { new_order.push($(this).val()); });
          $.post('/vocab_sheet/items/reorder/', {'items[]': new_order});
        }});
      }
      // change the name of vocab sheet items
      var submit_vocab_item = function(input){
        input.val($.trim(input.val()));
        if (input.val() === '') {
          input.val(input.next('.old_name').val());
        } else if (input.val() !== input.next('.old_name').val() && input.val() !== ''){
          var form = input.closest('form')
          $.post(form.attr('action'), form.serialize(), function(data){
            input.next('.old_name').val(data);
            input.val(data);
          });
        }
      }
      $('.vocab_sheet textarea, input.vocab_sheet_name').keypress(function(e){
        if (e.which == 13) {
          e.preventDefault()
          $(this).blur();
          return false;
        } else {
          return true;
        }
      }).blur(function(){submit_vocab_item($(this))});
      if (document.printView){
        $('textarea').attr('readonly', true);
      }
    }
  }
  
  var setup_feedback_form = function(){
    $('#feedback_include_sign, #feedback_change_sign').change(function(){
      $('.if_'+$(this).attr('id')).toggle(this.checked);
    }).trigger('change')
  }
  var setup_keyword_autocomplete = function(){
    var input = $('#s')
    input.autocomplete({
      source: '/signs/autocomplete',
      delay:10,
      minLength:3,
      appendTo:input.parent()
    });
  }
  setup();
});