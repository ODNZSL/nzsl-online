$(document).ready(function() {
  if ($('.search-results__card').length > 0) {
    var searchResult = 0; // eslint-disable-line no-var
    var searchResultPlaceholder = 0;
    $('.search-results__card').each(function() {
      $(this)
        .css({
          transitionDelay: (searchResult * 0.1) + 's',
        })
        .addClass('show-card');
        searchResult++;
    });
    $(window).on('load', function() {
      $('.search-results--placeholder').each(function() {
        $(this)
          .css({
            transitionDelay: (searchResultPlaceholder * 0.1) + 's',
          })
          .addClass('hide-placeholder');
          searchResultPlaceholder++;
      });
    });
  };
});
