$(document).ready(function() {
  if ($('.vocab-sheet__text-input').length > 0) {
    $('.vocab-sheet__text-input').each(function() {
      autoExpandTextarea($(this));
    });

    $('.vocab-sheet__text-input').keyup(function() {
      autoExpandTextarea($(this));
    });

    function autoExpandTextarea(field) {
      var nameBeingChanged = '';
      var textHeight = field.prop('scrollHeight');

      if (field.hasClass('item-name')) {
        nameBeingChanged = '.item-name';
      } else if (field.hasClass('item-maori-name')) {
        nameBeingChanged = '.item-maori-name';
      }
      $(nameBeingChanged).each(function() {
        $(this).css({height: textHeight});
      });
    }
  }
});
