$(document).ready(function() {
  var searchResult = 0; // eslint-disable-line no-var
  if ($('.search-results__card').length > 0) {
    $('.search-results__card').each(function() {
      $(this)
        .css({
          transitionDelay: (searchResult * 0.1) + 's',
        })
        .addClass('show-card');
      searchResult++;
    });
    }
    $(window).on('load', function() {
      $('.search-results__card').removeClass('search-results--placeholder');
    });
});
