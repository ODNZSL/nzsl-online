$(document).ready(function () {
  if ($('.add-to-vocab-btn').length > 0) {
    var notice = '.vocab-sidebar .ajax-flash';
    var vocabList = '.vocab-sidebar ul';

    $('.add-to-vocab-btn').click(function (e) {
      e.preventDefault();
      addVocabItem($(this).attr('data-sign-id'));
    });

    if ($('.remove').length > 0) {
      removeVocabItemOnClick();
    }

    function removeVocabItemOnClick() {
      $('.remove').click(function (e) {
        e.preventDefault();
        removeVocabItem($(this).attr('data-sign-id'));
      });
    }

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
      }).done(function (data) {
        onVocabItemAdded(data);
      }).fail(function (error) {
        onVocabItemError(error.statusText);
      });
    }

    function onVocabItemAdded(htmlElem) {
      if ($('.vocab-sidebar').css('display') === 'none') {
        $('.vocab-sidebar').show();
      }

      $(notice).removeClass('hide-flash').text('Sign added');
      $(vocabList).append(htmlElem);
      removeVocabItemOnClick();
      hideNotice();
    }

    function removeVocabItem(itemId) {
      $.ajax({
        url: '/vocab_sheet/items/' + itemId,
        method: 'POST',
        data: {
          _method: 'delete',
        },
        headers: {
          'X-CSRF-Token': $('meta[name="authenticity-token"]').attr('content'),
        },
      }).done(function (data) {
        onVocabItemRemoved(itemId);
      }).fail(function (error) {
        onVocabItemError(error.statusText);
      });
    }

    function onVocabItemRemoved(itemId) {
      $(notice).removeClass('hide-flash').text('Sign removed');
      $('.vocab-sidebar__item[data-sign-id=' + itemId + ']').remove();
      hideNotice();
    }

    function onVocabItemError(errorMessage) {
      console.error(errorMessage);

      if ($('.vocab-sidebar').css('display') !== 'none') {
        $(notice)
          .removeClass('hide-flash')
          .addClass('error')
          .text('Error, please try again.');
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
      setTimeout(function () {
        $(notice).addClass('hide-flash').removeClass('error');
      }, 2000);
    }
  }

  if ($('.vocab-sidebar .flash').length > 0) {
    setTimeout(function () {
      $('.vocab-sidebar .flash').addClass('hide-flash');
    }, 2000);
  }
});
