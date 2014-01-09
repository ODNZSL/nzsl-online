(function(){
  var hide_vocab_bar_if_empty = function(){
    var bar = $('.vocab_sheet_bar');
    if (bar.length && bar.find('.vocab_sheet_bar_item').length === 0) {
      bar.hide();
      $('body').removeClass('vocab_sheet_background');
    }
  };

  var show_vocab_bar = function(){
    if ($('.vocab_sheet_bar').length){
      $('.vocab_sheet_bar').show();
      $('body').addClass('vocab_sheet_background');
    }
  };

  var setup_vocab_remove = function(){
    $('.remove').on('click', function(e){
      e.preventDefault();
      var button = $(this);
      var form = button.closest('form');
      $.post(form.attr('action'), form.serialize());
      button.closest('.vocab_sheet_item').animate({height:0}, 200, function(){
        $(this).remove();
        hide_vocab_bar_if_empty();
      });
    });
  };

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
  };

  setup_vocab_remove();
  setup_add_to_sheet();
})();
