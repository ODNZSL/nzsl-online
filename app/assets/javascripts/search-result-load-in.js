$(document).ready(function() {
  let searchResult = 0; // eslint-disable-line no-var

  $('.search-results__card').each(function() {
    $(this)
      .css({
        transitionDelay: (searchResult * 0.05) + 's',
      })
      .addClass('show-card').removeClass('placeholder_cover')
    searchResult++;
  });
});
