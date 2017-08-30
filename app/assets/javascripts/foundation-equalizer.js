// $(document).ready(function() {
//   $("#search-container").on("postequalized.zf.equalizer", function() {
//     debugger;
//     var resultsArray = [];
//     $results = $(resultsArray.push(".link_and_drawing_container"));
//     $results.each(function(){
//       console.log("found");
//       $(this).css("position", "absolute");
//       $(this).css("bottom", "0");
//     });
//     $('#search-container').fadeIn("slow");
//   });
//   $("#search-container").on("resizeme.zf.trigger mutateme.zf.trigger", function() {
//     var resultsArray = [];
//     $results = $(".link_and_drawing_container");
//     $results.each(function(){
//       resultsArray.push($(this).css("position", "relative"));
//     });
//   });
// });

$(document).ready(function() {
  $("#search-container").on("postequalized.zf.equalizer", function() {
    // debugger;
    $results = $(".link_and_drawing_container");
    $results.each(function(){
      console.log("found");
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
});