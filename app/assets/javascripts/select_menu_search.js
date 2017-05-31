$(document).ready(function() {
  $('.usage-dropdown').click(function(e) {
    e.preventDefault();
    var id = $(this).attr('id');
    removeStyle($('.usage-dropdown'))
    addStyle($(this));
    clearDropdown($('.usage-dropdown'));
    $('#usage').val(id)
  })

  $('.topic-dropdown').click(function(e) {
    e.preventDefault();
    var id = $(this).attr('id');
    removeStyle($('.topic-dropdown'))
    addStyle($(this));
    clearDropdown($('.topic-dropdown'));
    $('#tag').val(id)
  })

  function addStyle(listElement) {
    listElement.css("background-color", "#F0F6FA")
               .addClass('selected');
  }

  function removeStyle(listElements) {
    listElements.removeClass('selected')
                .css("background-color", "");
  }

// Make sure clear x is displayed as soon as dropdown items are clicked, and
// clear styles if button is clicked

  function clearDropdown(list) {
    $('.empty').css("display", "block")
    $('.empty').click(function() {
      list.css("background-color", "");
    })
  }

// remember dropdown state after search form submitted

  function topicState() {
    var elementID = $('#tag').val();
    var elementValue = $('li[class="topic-dropdown"][id="' + elementID + '"]');
    addStyle(elementValue);
    elementID === true ? clearDropdown(elementValue) : false
  }

  function usageState() {
    var elementID = $('#usage').val();
    var elementValue = $('li[class="usage-dropdown"][id="' + elementID + '"]');
    addStyle(elementValue);
    elementID === true ? clearDropdown(elementValue) : false
  }

  topicState();
  usageState();
})
