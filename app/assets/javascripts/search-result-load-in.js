$(document).ready(function() {
  if ($('.search-results__card').length > 0) {
    var searchResult = 0; // eslint-disable-line no-var
    var searchResultPlaceholder = 0;
    $('.search-results__card').each(function() {
      resultTransition($(this), searchResult, 'show-card');
      searchResult++;
    });

    $(window).on('load', function() {
      $('.search-results--placeholder').each(function() {
        resultTransition($(this), searchResultPlaceholder, 'hide-placeholder');
        searchResultPlaceholder++;
      });
    });

    function resultTransition(searchResultItem, counter, transitionClass) {
      searchResultItem
        .css({
          transitionDelay: (counter * 0.1) + 's',
        })
        .addClass(transitionClass);
    }
  };
});
