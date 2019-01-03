$(document).ready(function() {
  $('.clickable_link').click(function() {
    window.location = $(this)
      .find('a')
      .attr('href');
  });

  function hideBackButton() {
    if ($('.back_to_search_results').length === 0) {
      $('.back-arrow-icon').css('display', 'none');
    } else {
      $('.back-arrow-icon').css('display', 'block');
    }
  }

  hideBackButton();
});
