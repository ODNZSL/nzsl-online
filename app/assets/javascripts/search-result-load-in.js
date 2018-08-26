$(document).ready(function() {
  var searchResult = 0; // eslint-disable-line no-var
  $('.search-results__card').each(function() {
    $(this)
      .css({
        transitionDelay: (searchResult * 0.1) + 's',
      })
      .addClass('show-card');
      searchResult++;
  });
    if ($('.search-results__card').length > 0) {
      $(window).on('load', function() {
        $('.search-results__card').removeClass('search-results--placeholder');
      });
    }
});
