$(document).ready(function() {
  if ($('.vocab-sidebar').length > 0) {
    var bar = $('.vocab-sidebar');
    var searchResultBanner = $('.search-result-banner');
    var offset = searchResultBanner.offset().top;
    var bottom = offset + searchResultBanner.outerHeight(true);
    var baseMargin = 24; // 1.5rem
    var barBottom = bar.offset().top + bar.outerHeight(true) + baseMargin;
    var initialOffset = bottom + baseMargin;
    var footerTop = $('.sticky_footer').offset().top;

    function positionVocabBar() {
      var windowScroll = $(window).scrollTop();

      if (windowScroll < bottom) {
        bar.css({top: initialOffset - offset});
      } else if (barBottom < footerTop ||
        (windowScroll < footerTop - (bar.outerHeight(true) + baseMargin))) {
        bar.css({top: windowScroll - offset + baseMargin});
      }
    }

    function checkVocabBarHeight() {
      if (barBottom > footerTop) {
        bar.css({height: $('.search-results__container').innerHeight(),});
      }

      $('.vocab-sidebar__list').css({
        height: bar.innerHeight() - $('.vocab-sidebar__header').innerHeight(),
      });
    }

    $(window).scroll(function() {
      positionVocabBar();
    });

    $(window).resize(function() {
      footerTop = $('.sticky_footer').offset().top;
    });

    checkVocabBarHeight();
    positionVocabBar();
  }
});
