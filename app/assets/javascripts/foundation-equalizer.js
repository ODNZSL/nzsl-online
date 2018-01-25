$(document).ready(function() {
    if ($("#search-container").children().length === 1) {
    $('#search-container').fadeIn(1000);
    } else {
    $("#search-container").on("postequalized.zf.equalizer", function() {
      $results = $(".link_and_drawing_container");
      $results.each(function(){
        $(this).css("position", "absolute");
        $(this).css("bottom", "0");
      });
      $('#search-container').fadeIn("slow");
    });
    $("#search-container").on("resizeme.zf.trigger mutateme.zf.trigger", function() {
      $results = $(".link_and_drawing_container");
      $results.each(function(){
        $(this).css("position", "relative");
      });
    });
  }
});