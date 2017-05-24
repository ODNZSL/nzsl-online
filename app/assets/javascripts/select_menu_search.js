$(document).ready(function() {

  $('.usage-dropdown').click(function(e) {
    e.preventDefault;
    var id = $(this).attr('id');
    removeStyle($('.usage-dropdown'))
    addStyle($(this));
    clearDropdown($('.usage-dropdown'));
    $('#usage').val(id)
  })

  $('.topic-dropdown').click(function(e) {
    e.preventDefault;
    var id = $(this).attr('id');
    removeStyle($('.topic-dropdown'))
    addStyle($(this));
    clearDropdown($('.topic-dropdown'));
    $('#tag').val(id)
  })

  function addStyle(listItem) {
    listItem.css("background-color", "#F0F6FA")
           .addClass('selected');
  }

  function removeStyle(list) {
    list.removeClass('selected')
             .css("background-color", "");
  }

  function clearDropdown(list) {
    $('.empty').css("display", "block")
    $('.empty').click(function() {
      list.css("background-color");
    })
  }
})
