$(document).ready(function() {
  $(".add-to-vocab-btn").click(function (e) {
    e.preventDefault();
    var sign_id = $(this).attr("data-sign-id");

    var successNotice = '<div class="flash vocab_var_notice ajax-success-response">You have added a sign to your vocab sheet.</div>';
    var failureNotice = '<div class="flash vocab_var_notice ajax-failure-response">There was an error adding a sign to your vocab sheet.</div>';
    var vocabList = ".vocab_sheet_bar ul";

    $.ajax({
      url: "/vocab_sheet/items/",
      method: "POST",
      data: { sign_id },
      headers: { 'X-CSRF-Token': $('meta[name="authenticity-token"]').attr('content') }
    }).done(function (data) {
      $(successNotice).insertBefore(vocabList);
      $(vocabList).append(data);

      setTimeout(function () {
        $(".ajax-success-response").remove();
      }, 2000);
    }).fail(function (error) {
      console.error(error.statusText);
      $(failureNotice).insertBefore(vocabList);

      setTimeout(function () {
        $(".ajax-failure-response").remove();
      }, 2000);
    });
  });
});
