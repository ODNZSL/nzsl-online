$(document).ready(function() {

  function hideVocabSheetOnMobile() {
    var bar = $('.vocab_sheet_bar');
    var windowWidth = $(window).width();
    if(windowWidth < 640 || (bar.length && bar.find('.vocab_sheet_bar_item').length === 0)) {
      bar.hide();
      $('.not_sticky_footer').removeClass('vocab_sheet_background');
    } else if (windowWidth > 639 &&  bar.length) {
      bar.show();
      $('.not_sticky_footer').addClass('vocab_sheet_background');
    }
  }

  $(window).resize(function() {
    hideVocabSheetOnMobile();
  })

  hideVocabSheetOnMobile();
});
