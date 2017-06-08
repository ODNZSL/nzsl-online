$(document).ready(function() {
  var $images = $('#search-container').find("img");
  Foundation.onImagesLoaded($images, function() {
    $('#search-container').fadeIn("slow")
    var equalizer = new Foundation.Equalizer($('#search-container'));
  });
  var homeEqualizer = new Foundation.Equalizer($('#sign-content-container'));
});
