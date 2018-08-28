$(document).ready(function() {
  if ($('.vocab-sheet__bar').length > 0) {
    var bar = $('.vocab-sheet__bar');

    function hideVocabSheetOnMobile() {
      var windowWidth = $(window).width();
      if (windowWidth < 640 || (bar.length && bar.find('.vocab-sheet__bar-item').length === 0)) {
        bar.hide();
        $('.not_sticky_footer').removeClass('vocab_sheet_background');
      } else if (windowWidth > 639 &&  bar.length) {
        bar.show();
        $('.not_sticky_footer').addClass('vocab_sheet_background');
      }
    }

    function positionVocabBar() {
      var searchResultBanner = $('.search-result-banner');
      var offset = searchResultBanner.offset().top;
      var bottom = offset + searchResultBanner.outerHeight(true);
      var baseMargin = 24; // 1.5rem
      var initialOffset = bottom + baseMargin;
      var windowScroll = $(window).scrollTop();
      var footerTop = $('.sticky_footer').offset().top;
      var barBottom = bar.offset().top + bar.outerHeight(true) + baseMargin;

      if (windowScroll < bottom) {
        bar.css({top: initialOffset - offset});
      } else if (barBottom < footerTop ||
        (windowScroll < footerTop - (bar.outerHeight(true) + baseMargin))) {
        bar.css({top: windowScroll - offset + baseMargin});
      }
    }

    $(window).resize(function() {
      hideVocabSheetOnMobile();
    });

    $(window).scroll(function() {
      positionVocabBar();
    });

    positionVocabBar();
    hideVocabSheetOnMobile();
  }
});
