$(document).ready(function() {

  if(Modernizr.touch && !Foundation.MediaQuery.atLeast('large')) {
    $('.play-button').hide();
    $('video').each(function() {
      $(this).prop('controls', true);
      $(this).prop('controlsList', 'nodownload');
    })
  }

  $('video').click(function(e) {
    if($('.play-button').length) {
      e.preventDefault();
      videoResponse(this);
    }
  });

  $('.play-button').click(function(e) {
    e.preventDefault();
    videoResponse(this.nextElementSibling);
  });

  function videoResponse(video) {
    video.paused == true ? playVideo(video) : pauseVideo(video);
  }

  function playVideo(video) {
    pauseOtherVideos(video);
    $(video).closest('.video-container').children('.play-button').css('visibility', 'hidden');
    $(video).get(0).play();
  }

  function pauseVideo(video) {
    $(video).closest('.video-container').children('.play-button').css('visibility', 'visible');
    $(video).get(0).pause();
  }

  function pauseOtherVideos(currentVideo) {
    $('video').each(function() {
      if (this != currentVideo) { pauseVideo(this); }
    });
  }
});
