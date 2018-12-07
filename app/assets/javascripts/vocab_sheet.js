$(document).ready(function() {
  var typeTimer = null;

  var setup_vocab_sheet_page = function() {
    // Reorder vocab sheet items
    if ($('ul#vocab_sheet').length) {
      $('ul#vocab_sheet .button, .vocab_sheet_name .button').hide();
      if (!document.printView) {
        $('ul#vocab_sheet').sortable({
          containment: 'parent',
          update: function(event, ui) {
            var new_order = [];
            $('ul#vocab_sheet .item_id').each(function() { new_order.push($(this).val()); });
            $.post('/vocab_sheet/items/reorder/', { 'items[]': new_order });
          }
        });
      }

      // Change the name of vocab sheet
      var submit_vocab_sheet_name = function(input) {
        input.val($.trim(input.val()));
        if (input.val() === '') {
          input.val(input.next('.old_name').val());
        } else if (input.val() !== input.next('.old_name').val() && input.val() !== '') {
          var form = input.closest('form');
          $.post(form.attr('action'), form.serialize(), function(data) {
            input.next('.old_name').val(data.vocab_sheet.name);
            input.val(data.vocab_sheet.name);
          });
        }
      };

      $('input.vocab_sheet_name').keypress(function(e) {
        if (e.which == 13) {
          e.preventDefault();
          $(this).blur();
          return false;
        }
        return true;
      });
      $('input.vocab_sheet_name').blur(function() { submit_vocab_sheet_name($(this)); });

      if (document.printView) {
        $('img.vocab-download-button').remove();
        $('textarea').attr('readonly', true);
      }
    }

    $('.vocab-sheet__page-controls--download').on('click', function() {
      $('.vocab-sheet__download-notice').removeClass('hide');
    });
    $('button.orange_submit_button').on('click', function() {
      $('span.icon-container').remove();
    });
  };

  if ($('.input-with-character-count').length > 0) {
    var textBoxes = $('.input-with-character-count textarea');

    function checkCharacterCount() {
      textBoxes.each(function() {
        setupCharacterCount($(this));
      });

      textBoxes.keypress(function() {
        checkForMaxLength($(this));
      });

      textBoxes.keyup(function() {
        setCharacterCount($(this));
      });
    }

    function setupCharacterCount(elem) {
      var notes = elem.val();
      var maxLength = elem.attr('maxlength');

      if (notes !== '') {
        elem.siblings('.character-count__wrap')
          .children('.character-count__count')
          .text(maxLength - notes.length);
      }
    }

    function checkForMaxLength(elem) {
      var notes = elem.val();
      var maxLength = elem.attr('maxlength');

      if (notes.length >= maxLength) {
        elem.addClass('max-length-reached');

        setTimeout(function() {
          textBoxes.removeClass('max-length-reached');
        }, 1000);
      }
    }

    function setCharacterCount(elem) {
      var notes = elem.val();
      var maxLength = elem.attr('maxlength');

      elem.siblings('.character-count__wrap')
        .children('.character-count__count')
        .text(maxLength - notes.length);
    }

    checkCharacterCount();
  }

  if ($('.vocab-sheet__text-input').length > 0) {
    $('.vocab-sheet__text-input').keyup(function() {
      var field = $(this);
      var action = getFormAction(field);
      var data = {
        signId: getSignIdFromAction(action),
      };

      if (field.hasClass('item-name')) data.name = field.val();
      if (field.hasClass('item-maori-name')) data.maoriName = field.val();
      if (field.hasClass('item-notes')) data.notes = field.val();

      updateVocabItem(action, data);
    });
  }

  function updateVocabItem(action, params) {
    clearTimeout(typeTimer);

    typeTimer = setTimeout(function() {
      if (params.signId !== null) {
        $.ajax({
          url: action || '/vocab_sheet/items/' + params.signId,
          method: 'PUT',
          data: assignItemParams(params),
          headers: {
            'X-CSRF-Token': $('meta[name="authenticity-token"]').attr('content'),
          },
        }).fail(function(error) {
          console.error(error.statusText);
        });
      } else {
        console.error('Error, cannot update vocab sheet item without ID. Parameters presented:', params);
      }
    }, 100);
  }

  function assignItemParams(params) {
    var data = {};

    for (var param in params) {
      if (Object.prototype.hasOwnProperty.call(params, param)) {
        data[toSnakeCase(param)] = params[param];
      }
    }

    return data;
  }
  function getFormAction(field) {
    return field.closest('form').attr('action');
  }
  function getSignIdFromAction(action) {
    var actionSegments = action.split('/');
    return actionSegments[actionSegments.length - 1];
  }
  function toSnakeCase(varName) {
    return varName.split(/(?=[A-Z])/).join('_').toLowerCase();
  }

  setup_vocab_sheet_page();
});
