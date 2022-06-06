$(document).ready(function() {
  var hasPlayButton = true;

  adjustVideoControlsToScreenSize();

  $(window).resize(function() {
    adjustVideoControlsToScreenSize();
  });

  $('video').click(function(e) {
    if ($('.play-button').length) {
      e.preventDefault();
      videoResponse(this);
    }
  }).on('play', function(evt) {
    pauseOtherVideos(evt.target);
    hasPlayButton && $(evt.target)
        .closest('.video-container')
        .children('.play-button')
        .css('opacity', '0');
  });

  $('.play-button').click(function(e) {
    e.preventDefault();
    videoResponse(this.nextElementSibling);
  });

  function adjustVideoControlsToScreenSize() {
    if (Modernizr.touch && !Foundation.MediaQuery.atLeast('large')) {
      hasPlayButton = false;
      $('.play-button').hide();
      $('video').each(function() {
        $(this).prop('controls', true);
        $(this).prop('controlsList', 'nodownload');
      });
    } else {
      hasPlayButton = true;
      $('.play-button').show();
      $(this).prop('controls', false);
    }
  }

  function videoResponse(video) {
    video.paused ? video.play() : video.pause();
  }

  function pauseOtherVideos(currentVideo) {
    $('video').not(currentVideo).each(function() {
      this.pause();
    });
  }
});
