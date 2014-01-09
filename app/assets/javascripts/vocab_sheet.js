(function(){
  var setup_vocab_sheet_page = function(){
    // reorder vocab sheet items
    if ($('ul#vocab_sheet').length){
      $('ul#vocab_sheet .button, .vocab_sheet_name .button').hide();
      if (!document.printView){
        $('ul#vocab_sheet').sortable({containment: 'parent', update: function(event, ui) {
          new_order = [];
          $('ul#vocab_sheet .item_id').each(function() { new_order.push($(this).val()); });
          $.post('/vocab_sheet/items/reorder/', {'items[]': new_order});
        }});
      }

      // change the name of vocab sheet
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

      // change the name of vocab sheet items
      var submit_vocab_item_names = function(input){
        var form = input.closest('form');
        var item_name =       form.children('.item_name');
        var old_name =        form.children('.old_name');
        var item_maori_name = form.children('.item_maori_name');
        var old_maori_name =  form.children('.old_maori_name');

        item_name.val( $.trim(item_name.val()) );
        item_maori_name.val( $.trim(item_maori_name.val()) );

        if (item_name.val()  === '') {
          item_name.val(old_name.val());
        }
        if (item_maori_name.val()  === '') {
          item_maori_name.val(old_maori_name.val());
        }

        var form_empty = (  item_name.val()  === '' && 
                            item_maori_name.val()  === ''  );
        var form_unchanged =  ( item_name.val() === old_name.val() && 
                                item_maori_name.val() === old_maori_name.val() );

        if ( ! form_empty && ! form_unchanged ) {
          $.post(form.attr('action'), form.serialize(), function(data){
            var name = data.item.name;
            var maori_name = data.item.maori_name;

            item_name.val(name);
            old_name.val(name);
            item_maori_name.val(maori_name);
            old_maori_name.val(maori_name);
          });
        }
      };

      $('.vocab_sheet textarea, input.vocab_sheet_name').keypress(function(e){
        if (e.which == 13) {
          e.preventDefault();
          $(this).blur();
          return false;
        } else {
          return true;
        }
      });
      $('.vocab_sheet textarea').blur(function(){ submit_vocab_item_names($(this)); });
      $('input.vocab_sheet_name').blur(function(){ submit_vocab_sheet_name($(this)); });

      if (document.printView){
        $('textarea').attr('readonly', true);
      }
    }
  };

  setup_vocab_sheet_page();
})();
