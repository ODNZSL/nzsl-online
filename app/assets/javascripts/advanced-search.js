$(document).ready(function() {
  var windowWidth = $(window).width();
  $('.advanced a').click(function(e) {
    e.preventDefault();
    if(windowWidth >= 640) {
      $('.advanced-search-container').toggle();
    }
  });
});
