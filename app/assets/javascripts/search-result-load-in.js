$(document).ready(function() {
  var searchResult = 0; // eslint-disable-line no-var

  $('.search-results__card').each(function() {
    $(this)
      .css({
        transitionDelay: (searchResult * 0.05) + 's',
      })
      .addClass('show-card');
    searchResult++;
  });
});
