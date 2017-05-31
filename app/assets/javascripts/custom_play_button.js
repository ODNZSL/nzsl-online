$(document).ready(function() {
  if(Modernizr.touch) {
    $(".play-button").hide();
    $("video").each(function() { $(this).prop("controls", true); })
  }

  $("video").click(function(e) {
    e.preventDefault();
    this.paused == true ? playVideo($(this)):pauseVideo($(this));
  });

  function playVideo(container) {
    container.closest(".video-container").children(".play-button").css("visibility", "hidden");
    container.get(0).play();
  }

  function pauseVideo(container) {
    container.closest(".video-container").children(".play-button").css("visibility", "visible");
    container.get(0).pause();
  }

  $(document).click(function(e) {
    if(!$(e.target).hasClass("video")) {
      $(this).find("video").each(function() {
        pauseVideo($(this))
      });
    }
  })
});
