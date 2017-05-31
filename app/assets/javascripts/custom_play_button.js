$(document).ready(function() {
  $("video").click(function(e) {
    e.preventDefault();
    videoResponse(this);
  });

  $(".play-button").click(function(e) {
    e.preventDefault();
    videoResponse(this.nextElementSibling);
  });

  function videoResponse(video) {
    video.paused == true ? playVideo(video) : pauseVideo(video);
  }

  function playVideo(video) {
    pauseOtherVideos(video);
    $(video).closest(".video-container").children(".play-button").css("display", "none");
    $(video).get(0).play();
  }

  function pauseVideo(video) {
    $(video).closest(".video-container").children(".play-button").css("display", "inline-block");
    $(video).get(0).pause();
  }

  function pauseOtherVideos(currentVideo) {
    $("video").each(function() {
      if (this != currentVideo) { pauseVideo(this); }
    });
  }
});
