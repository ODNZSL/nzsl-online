$(document).ready(function() {
  $('.add-to-vocab-btn').click(function(e) {
    e.preventDefault();
    var signId = $(this).attr('data-sign-id');

    var successNotice =
      '<div class="flash vocab_var_notice ajax-success-response">'
      + 'You have added a sign to your vocab sheet.'
      + '</div>';

    var failureNotice =
      '<div class="flash vocab_var_notice ajax-failure-response">'
      + 'There was an error adding a sign to your vocab sheet.'
      + '</div>';

    var vocabList = '.vocab_sheet_bar ul';

    $.ajax({
      url: '/vocab_sheet/items/',
      method: 'POST',
      data: {
        sign_id: signId,
      },
      headers: {
        'X-CSRF-Token': $('meta[name="authenticity-token"]').attr('content'),
      },
    }).done(function(data) {
     if ($('.vocab_sheet_bar').css('display') === 'none') {
       $('.vocab_sheet_bar').show();
     }

      $(successNotice).insertBefore(vocabList);
      $(vocabList).append(data);

      setTimeout(function() {
        $('.ajax-success-response').remove();
      }, 2000);
    }).fail(function(error) {
      console.error(error.statusText);
      if ($('.vocab_sheet_bar').css('display') !== 'none') {
        $(failureNotice).insertBefore(vocabList);

        setTimeout(function() {
          $('.ajax-failure-response').remove();
        }, 2000);
      } else {
        $('.before_sticky_footer').prepend('<div class="flash notice">There was an error adding a sign to your vocab sheet.');
      }
    });
  });
});
