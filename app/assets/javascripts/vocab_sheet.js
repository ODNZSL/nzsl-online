$( document ).ready(function() {
  var setup_vocab_sheet_page = function(){
    // Reorder vocab sheet items
    if ($('ul#vocab_sheet').length){
      $('ul#vocab_sheet .button, .vocab_sheet_name .button').hide();
      if (!document.printView){
        $('ul#vocab_sheet').sortable({containment: 'parent', update: function(event, ui) {
          new_order = [];
          $('ul#vocab_sheet .item_id').each(function() { new_order.push($(this).val()); });
          $.post('/vocab_sheet/items/reorder/', {'items[]': new_order});
        }});
      }

      // Change the name of vocab sheet
      var submit_vocab_sheet_name = function(input){
        input.val($.trim(input.val()));
        if (input.val() === '') {
          input.val(input.next('.old_name').val());
        } else if (input.val() !== input.next('.old_name').val() && input.val() !== ''){
          var form = input.closest('form');
          $.post(form.attr('action'), form.serialize(), function(data){
            input.next('.old_name').val(data.vocab_sheet.name);
            input.val(data.vocab_sheet.name);
          });
        }
      };

      // Change the name of vocab sheet items
      var submit_vocab_item_names = function(input){
        var form = input.closest('form');
        var item_name =       form.children('.item_name');
        var old_name =        form.children('.old_name');
        var item_maori_name = form.children('.item_maori_name');
        var old_maori_name =  form.children('.old_maori_name');

        var form_unchanged =  ( item_name.val() === old_name.val() &&
                                item_maori_name.val() === old_maori_name.val() );

        if ( !form_unchanged ) {
          $.post(form.attr('action'), form.serialize());
        }
      };

      $('.vocab_sheet textarea, input.vocab_sheet_name').keypress(function(e){
        if (e.which == 13) {
          e.preventDefault();
          $(this).blur();
          return false;
        }
        return true;
      });
      $('.vocab_sheet textarea').blur(function(){ submit_vocab_item_names($(this)); });
      $('input.vocab_sheet_name').blur(function(){ submit_vocab_sheet_name($(this)); });

      if (document.printView){
        $('textarea').attr('readonly', true);
      }
    }
  };

  setup_vocab_sheet_page();
});
