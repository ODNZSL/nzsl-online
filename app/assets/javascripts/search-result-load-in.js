$(document).ready(function() {
  var searchResult = 0; // eslint-disable-line no-var
  $('.search-results__card').each(function() {
    $(this)
      .css({
        transitionDelay: (searchResult * 0.05) + 's',
      })
      .addClass('show-card');
      setTimeout(function() {
        $('.search-results__card').removeClass('search-results--placeholder');
      }, 2000);
    searchResult++;
  });
});
