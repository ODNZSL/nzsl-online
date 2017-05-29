$(document).ready(function() {
  $(".clickable_link").click(function() {
    window.location = $(this).find("a").attr("href");
  });
});