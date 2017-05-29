$(document).ready(function() {
  $('video').click(function(e) {
    e.preventDefault();
    this.paused == true ? playVideo($(this)):pauseVideo($(this))
  });

  function playVideo(container) {
    container.closest('.video-container').children('.play-button').css("display", "none");
    container.get(0).play();
  }

  function pauseVideo(container) {
    container.closest('.video-container').children('.play-button').css("display", "inline-block");
    container.get(0).pause();
  }

  $(document).click(function(e) {
    if(!$(e.target).hasClass('video')) {
      $(this).find('video').each(function() {
        pauseVideo($(this))
      });
    }
  })
});
