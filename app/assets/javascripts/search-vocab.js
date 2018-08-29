$(document).ready(function() {
  if ($('.add-to-vocab-btn').length > 0) {
    var notice = '.vocab_sheet .ajax-flash';
    var vocabList = '.vocab-sidebar ul';

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
      if ($('.vocab-sidebar').css('display') === 'none') {
        $('.vocab-sidebar').show();
      }

      $(notice).addClass('show').text('Sign added');
      $(vocabList).append(htmlElem);
      hideNotice();
    }

    function onVocabItemError(errorMessage) {
      console.error(errorMessage);

      if ($('.vocab-sidebar').css('display') !== 'none') {
        $(notice).addClass('show error').text('Error, please try again.');
        hideNotice();
      } else {
        $('.before_sticky_footer').prepend(
          '<div class="flash error">'
          + 'Error, please try again.'
          + '</div>'
        );
      }
    }

    function hideNotice() {
      setTimeout(function() {
        $(notice).removeClass('show error');
      }, 2000);
    }
  }

  if ($('.vocab_bar_notice').length > 0) {
    setTimeout(function() {
      $('.vocab_bar_notice').removeClass('show');
    }, 2000);
  }
});
