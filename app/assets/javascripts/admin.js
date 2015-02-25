$(function(){
  // $('.ckeditor').ckeditor();
  $('ul.record').sortable({containment: 'parent', update: function(event, ui) {
    new_order = [];
    $('ul.record li').each(function() { new_order.push($(this).attr('id').replace('id', '')); });
    var reorder_path = window.location.pathname.replace(/((edit|new)\/?)$/, 'page_parts').replace(/(\/)$/,'') + '/reorder';
    $.post(reorder_path, {'items[]': new_order});
  }});
});
