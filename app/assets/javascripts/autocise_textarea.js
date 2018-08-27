// Get the max height and apply
// to all textareas when page loads/reloads

$(document).ready(function() {
  var numberArray = [];
  $('textarea').each(function(textarea) {
    $(this).height( $(this)[0].scrollHeight );
    numberArray.push($(this).innerHeight());
    var max = Math.max(...numberArray);
    $(this).innerHeight(max);
  });
});

// Use an event to listen to all input events and then
// filter out ones that are not on a textarea
// if the element is a textarea we will call a
// autoExpandTextarea function and pass in
// the element as an argument using event.target.
document.addEventListener('input', function(event) {
  if (event.target.tagName.toLowerCase() !== 'textarea') return;
  autoExpandTextarea(event.target);
}, false);

var autoExpandTextarea = function(field) {
  // check the field parameter class so we can give the
  // same height to other textareas with same class.
  var checkIsMain = field.classList.contains('item_name');
  var checkIsMaori = field.classList.contains('item_maori_name');

  // Reset field height
  field.style.height = 'inherit';

  // get computed styles for the element and
  // scrollheight to calculate height of the content.
  var computed = window.getComputedStyle(field);

  // Calculate the height
  var height = parseInt(computed.getPropertyValue('border-top-width'), 10)
               + parseInt(computed.getPropertyValue('padding-top'), 10)
               + field.scrollHeight
               + parseInt(computed.getPropertyValue('padding-bottom'), 10)
               + parseInt(computed.getPropertyValue('border-bottom-width'), 10);
  // Reset height of element using style property or just use the ifs?
  field.style.height = height + 'px';

  // alter textarea row height to make consistent and even.
  if(checkIsMain || checkIsMaori) {
    for(var i = 0,  j = 0; i < checkIsMain.length, j < checkIsMaori.length; i++, j++) {
       checkIsMain[i].style.height = height + 'px';
       checkIsMaori[j].style.height = height + 'px';
    }
  }
};
