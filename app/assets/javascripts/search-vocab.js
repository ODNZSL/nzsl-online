$(document).ready(function() {
  if ($('.add-to-vocab-btn').length > 0) {
    var notice = '.vocab_sheet .ajax-flash';
    var vocabList = '.vocab_sheet_bar ul';

    $('.add-to-vocab-btn').click(function(e) {
      e.preventDefault();
      addVocabItem($(this).attr('data-sign-id'));
    });

    function addVocabItem(signId) {
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
        onVocabItemAdded(data);
      }).fail(function(error) {
        onVocabItemError(error.statusText);
      });
    }

    function onVocabItemAdded(htmlElem) {
      if ($('.vocab_sheet_bar').css('display') === 'none') {
        $('.vocab_sheet_bar').show();
      }

      $(notice).show().text('You have added a sign to your vocab sheet.');
      $(vocabList).append(htmlElem);
      hideNotice();
    }

    function onVocabItemError(errorMessage) {
      console.error(errorMessage);

      if ($('.vocab_sheet_bar').css('display') !== 'none') {
        $(notice).show().text(
          'There was an error adding a sign to your vocab sheet.'
        );
        hideNotice();
      } else {
        $('.before_sticky_footer').prepend(
          '<div class="flash notice">'
          + 'There was an error adding a sign to your vocab sheet.'
          + '</div>'
        );
      }
    }

    function hideNotice() {
      setTimeout(function() {
        $(notice).hide();
      }, 2000);
    }
  }
});
