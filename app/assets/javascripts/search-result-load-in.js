$(document).ready(function() {
  var searchResult = 0; // eslint-disable-line no-var
  $('.search-results__card').each(function() {
    $(this)
      .css({
        transitionDelay: (searchResult * 0.05) + 's',
      })
      .removeClass('search-results--placeholder')
      .addClass('show-card');
    searchResult++;
  });
});
