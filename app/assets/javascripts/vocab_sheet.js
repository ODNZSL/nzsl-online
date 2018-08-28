$(document).ready(function() {
  var setup_vocab_sheet_page = function() {
    // Reorder vocab sheet items
    if ($('ul#vocab_sheet').length) {
      $('ul#vocab_sheet .button, .vocab_sheet_name .button').hide();
      if (!document.printView) {
        $('ul#vocab_sheet').sortable({containment: 'parent', update: function(event, ui) {
          var new_order = [];
          $('ul#vocab_sheet .item_id').each(function() { new_order.push($(this).val()); });
          $.post('/vocab_sheet/items/reorder/', {'items[]': new_order});
        }});
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

      // Change the name of vocab sheet items
      var submit_vocab_item_names = function(input) {
        var form = input.closest('form');
        var item_name =       form.children('.item_name');
        var old_name =        form.children('.old_name');
        var item_maori_name = form.children('.item_maori_name');
        var old_maori_name =  form.children('.old_maori_name');

        var form_unchanged =  (item_name.val() === old_name.val() &&
                                item_maori_name.val() === old_maori_name.val());

        if (!form_unchanged) {
          $.post(form.attr('action'), form.serialize());
        }
      };

      $('.vocab_sheet textarea, input.vocab_sheet_name').keypress(function(e) {
        if (e.which == 13) {
          e.preventDefault();
          $(this).blur();
          return false;
        }
        return true;
      });
      $('.vocab_sheet textarea').blur(function() { submit_vocab_item_names($(this)); });
      $('input.vocab_sheet_name').blur(function() { submit_vocab_sheet_name($(this)); });

      if (document.printView) {
        $('textarea').attr('readonly', true);
      }
    }
  };

  if ($('.input-with-character-count').length > 0) {
    var textBox = $('.input-with-character-count textarea');
    var maxLength = textBox.attr('maxlength');
    var formAction = textBox.closest('form').attr('action');
    var signId = formAction.split('/')[-1];
    var notes = '';
    var typeTimer = null;

    var checkCharacterCount = function() {
      textBox.each(function() {
        setupCharacterCount($(this));
      });

      textBox.keypress(function() {
        checkForMaxLength($(this));
      });

      textBox.keyup(function() {
        setCharacterCount($(this));
      });
    };

    function setupCharacterCount(elem) {
      notes = elem.val();

      if (notes !== '') {
        elem.siblings('.character-count__wrap')
          .children('.character-count__count')
          .text(maxLength - notes.length);
      }
    }

    function checkForMaxLength(elem) {
      notes = elem.val();

      if (notes.length >= maxLength) {
        elem.addClass('max-length-reached');

        setTimeout(function() {
          textBox.removeClass('max-length-reached');
        }, 1000);
      }
    }

    function setCharacterCount(elem) {
      clearTimeout(typeTimer);

      typeTimer = setTimeout(function() {
        notes = elem.val();

        elem.siblings('.character-count__wrap')
          .children('.character-count__count')
          .text(500 - notes.length);

        updateNotes(formAction, signId, notes);
      }, 100);
    }

    function updateNotes(action, signId, notes) {
      $.ajax({
        url: action,
        method: 'PUT',
        data: {
          sign_id: signId,
          notes: notes,
        },
        headers: {
          'X-CSRF-Token': $('meta[name="authenticity-token"]').attr('content'),
        },
      }).done(function(data) {
        // console.log("success!", data)
      }).fail(function(error) {
        console.error(error.statusText);
      });
    }

    checkCharacterCount();
  };

  setup_vocab_sheet_page();
});
