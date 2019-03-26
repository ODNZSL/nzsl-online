$(document).ready(function () {
  adjustVideoControlsToScreenSize();

  $(window).resize(function () {
    adjustVideoControlsToScreenSize();
  });

  $('video').click(function (e) {
    if ($('.play-button').length) {
      e.preventDefault();
      videoResponse(this);
    }
  });

  $('.play-button').click(function (e) {
    e.preventDefault();
    videoResponse(this.nextElementSibling);
  });

  function adjustVideoControlsToScreenSize() {
    if (Modernizr.touch && !Foundation.MediaQuery.atLeast('large')) {
      $('.play-button').hide();
      $('video').each(function () {
        $(this).prop('controls', true);
        $(this).prop('controlsList', 'nodownload');
      });
    } else {
      $('.play-button').show();
      $(this).prop('controls', false);
    }
  }

  function videoResponse(video) {
    video.paused == true ? playVideo(video) : pauseVideo(video);
  }

  function playVideo(video) {
    pauseOtherVideos(video);
    $(video)
      .closest('.video-container')
      .children('.play-button')
      .css('opacity', '0');
    $(video)
      .get(0)
      .play();
  }

  function pauseVideo(video) {
    $(video)
      .closest('.video-container')
      .children('.play-button')
      .css('opacity', '0');
    $(video)
      .get(0)
      .pause();
  }

  function pauseOtherVideos(currentVideo) {
    $('video').each(function () {
      if (this != currentVideo) {
        pauseVideo(this);
      }
    });
  }
});
