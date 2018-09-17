$(document).ready(function() {
  $('.clickable_link').click(function() {
    window.location = $(this).find('a').attr('href');
  });

  function hideBackButton() {
    if ($('.back_to_search_results').length === 0 ) {
      $('.back-arrow-icon').css('display', 'block');
      var backToSearchResults = '<a href="">Back to search results</a>'
      $('.back-button-container').append(backToSearchResults);
      $('.back-button-container a').click(function(){
        parent.history.back();
        return false;
      })
    } else {
      $('.back-arrow-icon').css('display', 'block');
    }
  }

  hideBackButton();
});
