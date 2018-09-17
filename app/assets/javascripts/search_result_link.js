$(document).ready(function() {
  $('.clickable_link').click(function() {
    window.location = $(this).find('a').attr('href');
  });

  function hideBackButton() {
    if ($('.back_to_search_results').length === 0 ) {
      $('.back-arrow-icon').css('display', 'block');
      // var backTo = '<a href=“javascript:history.go(-2)”>Back to search results</a>'
      var backTo = '<a href="">Back to search results</a>'
      $('.back-button-container').append(backTo);
    } else {
      $('.back-arrow-icon').css('display', 'block');
    }
  }

  hideBackButton();
});
