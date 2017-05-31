$(document).ready(function() {
  $("video").click(function(e) {
    e.preventDefault();
    this.paused == true ? playVideo(this) : pauseVideo(this);
  });

  function playVideo(container) {
    pauseOtherVideos(container);
    $(container).closest(".video-container").children(".play-button").css("display", "none");
    $(container).get(0).play();
  }

  function pauseVideo(container) {
    $(container).closest(".video-container").children(".play-button").css("display", "inline-block");
    $(container).get(0).pause();
  }

  function pauseOtherVideos(currentVideo) {
    $("video").each(function() {
      if (this != currentVideo) { pauseVideo(this); }
    });
  }
});
