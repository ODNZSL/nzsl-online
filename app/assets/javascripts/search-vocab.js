$(document).ready(function() {
  $(".add-to-vocab-btn").click(function (e) {
    e.preventDefault();
    var sign_id = $(this).attr("data-sign-id");

    $.ajax({
      url: "/vocab_sheet/items/",
      method: "POST",
      data: { sign_id },
      headers: { 'X-CSRF-Token': $('meta[name="authenticity-token"]').attr('content') }
    }).done(function (data) {
      console.log(data);
    });
  });
});
