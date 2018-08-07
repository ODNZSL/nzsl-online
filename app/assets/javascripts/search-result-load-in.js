$(document).ready(function() {
  var searchResult = 0;

  $(".search-result__float-wrapper").each(function () {
    $(this)
      .css({
        transitionDelay: (searchResult * 0.05) + "s"
      })
      .addClass("show");
    searchResult++;
  });
});