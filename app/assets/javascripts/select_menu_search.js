$(document).ready(function() {

  $('.usage-dropdown').click(function() {
    select($(this), '.usage-dropdown', '#usage');
  });

  $('.topic-dropdown').click(function() {
    select($(this), '.topic-dropdown', '#tag');
  });

  function select(target, targetClass, searchContainerId) {
    var id;
    $(targetClass).not(target).removeClass('selected');
    target.toggleClass('selected');

    if (target.hasClass('selected')) {
      id = target.attr('id');
      $('.empty').css('display', 'inline-block');
    } else {
      id = '';
      $('.empty').css('display', 'none');
    }
    $(searchContainerId).val(id);
  }

  function dropdownState(searchContainerId, targetClass) {
    var targetId = $(searchContainerId).val();
    var targetValue = $('li[class="' + targetClass +'"][id="' + targetId + '"]');
    targetValue.addClass('selected');
  }

  dropdownState('#tag', 'topic-dropdown');
  dropdownState('#usage', 'usage-dropdown');
});
