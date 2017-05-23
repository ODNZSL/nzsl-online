$(document).ready(function() {

  $('.usage-dropdown').click(function(e) {
    e.preventDefault;
    var id = $(this).attr('id');
    removeStyle($('.usage-dropdown'))
    addStyle($(this));
    $('#usage').val(id)
  })

  $('.topic-dropdown').click(function(e) {
    e.preventDefault;
    var id = $(this).attr('id');
    removeStyle($('.topic-dropdown'))
    addStyle($(this));
    $('#tag').val(id)
  })

  function addStyle(item) {
    item.css("background-color", "#F0F6FA")
           .addClass('selected');
  }

  function removeStyle(className) {
    className.removeClass('selected')
             .css("background-color", "");
  }
})
