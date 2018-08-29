$(document).ready(function() {
  if ($('.vocab-sidebar').length > 0) {
    var bar = $('.vocab-sidebar');
    var searchResultBanner = $('.search-result-banner');
    var offset = searchResultBanner.offset().top;
    var bottom = offset + searchResultBanner.outerHeight(true);
    var baseMargin = 24; // 1.5rem
    var initialOffset = bottom + baseMargin;
    var footerTop = $('.sticky_footer').offset().top;

    function positionVocabBar() {
      var windowScroll = $(window).scrollTop();
      var barBottom = bar.offset().top + bar.outerHeight(true) + baseMargin;

      if (windowScroll < bottom) {
        bar.css({top: initialOffset - offset});
      } else if (barBottom < footerTop ||
        (windowScroll < footerTop - (bar.outerHeight(true) + baseMargin))) {
        bar.css({top: windowScroll - offset + baseMargin});
      }
    }

    $(window).scroll(function() {
      positionVocabBar();
    });

    $(window).resize(function() {
      footerTop = $('.sticky_footer').offset().top;
    });

    positionVocabBar();
  }
});
