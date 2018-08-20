// Use an event to listen to all input events and then filter out ones that are not on a textarea
// if the element is a textarea we will call a auto_expand function
// and pass in the element as an argument using event.target.
document.addEventListener('input', function (event) {
  if (event.target.tagName.toLowerCase() !== 'textarea') return;
  auto_expand(event.target);
}, false);

var auto_expand = function (field) {
  // Reset field height
  field.style.height = 'inherit';
  // get computed styles for the element and scrollheight to calculate height of the content.
  var computed = window.getComputedStyle(field);
  // Calculate the height
  var height = parseInt(computed.getPropertyValue('border-top-width'), 10)
               + parseInt(computed.getPropertyValue('padding-top'), 10)
               + field.scrollHeight
               + parseInt(computed.getPropertyValue('padding-bottom'), 10)
               + parseInt(computed.getPropertyValue('border-bottom-width'), 10);
  // Reset height of element using style property
  field.style.height = height + 'px';

};
