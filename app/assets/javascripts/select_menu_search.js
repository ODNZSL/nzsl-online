$(document).ready(function() {
  $('.usage-dropdown').click(function(e) {
    e.preventDefault;
    var id = $(this).attr('id');
    $('#usage').val(id)
  })
  $('.topic-dropdown').click(function(e) {
    e.preventDefault;
    var id = $(this).attr('id');
    $('#tag').val(id)
  })
})
