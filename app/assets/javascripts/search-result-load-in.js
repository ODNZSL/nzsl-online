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
        console.log("placeholder removing");
      }, searchResult * 200 );
    searchResult++;
  });
});
// $(window).on('load', function(){
//   $('.search-results__card').addClass('search-results--placeholder');
//   console.log("window loaded with placeholder:");
// });
