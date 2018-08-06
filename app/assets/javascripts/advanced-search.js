$(document).ready(function() {
  var windowWidth = $(window).width();
  $('.search-tab a').click(function(e) {
    e.preventDefault();
    if(windowWidth >= 640) {
      $('.advanced-search-container').toggle();
      $('.vocab_sheet_bar').toggleClass('advanced-search-open');
    }
  });
});
