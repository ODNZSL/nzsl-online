$(document).ready(function() {
  var windowWidth = $(window).width();
  $('.advanced a').click(function(e) {
    e.preventDefault();
    if(windowWidth >= 640) {
      $('.advanced-search-container').removeClass('hide');
      $('.advanced-search-container').addClass('show')
    } else {
      $('.advanced-search-container').removeClass('show')
      $('.advanced-search-container').addClass('hide')
    }
  });
});
