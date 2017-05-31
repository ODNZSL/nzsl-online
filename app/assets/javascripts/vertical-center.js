$(document).ready(function() {

  function verticalCenter(containerClass, imageClass) {
    var height = containerClass.height();
    var marginTop = (height - 180) / 2;
    imageClass.css("margin-top", marginTop);
  }

  $(window).resize(function() {
    verticalCenter($('.video-container'), $('.sign-image'))
  })
  // setTimeout as otherwise document gets height before container filled.
  setTimeout(verticalCenter($('.video-container'), $('.sign-image')), 3000);
})
