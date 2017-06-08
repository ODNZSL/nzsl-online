$(function(){
  // $('.ckeditor').ckeditor();
  $('tbody.sortable').sortable({containment: 'parent', update: function(/* event, ui*/) {
    var new_order = [];
    console.log(new_order);
    $('tbody.sortable tr').each(function() {
      var page_id = $(this).attr('id').replace('id', '');
      new_order.push(page_id);
      console.log(new_order);
    });
    console.log(new_order);
    var reorder_path = window.location.pathname.replace(/((edit|new)\/?)$/, 'page_parts').replace(/(\/)$/,'') + '/reorder';
    $.post(reorder_path, {'items[]': new_order});
  }});
});
