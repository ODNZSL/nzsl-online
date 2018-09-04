$(document).ready(function() {
  if ($('.search-results__card').length > 0) {
    // # Why is so much of this commented?
    // The Jira story has been rejected with this implementation as of last sprint ending on 31/08/2018.
    // We will rework this, but currently we're disabling it for a production deploy that doesn't lose our progress.
    // If you're reading this comment a month into the future, probably just delete this file and move on with life.

    var searchResult = 0; // eslint-disable-line no-var
    // var searchResultPlaceholder = 0;
    $('.search-results__card').each(function() {
      resultTransition($(this), searchResult, 'show-card');
      searchResult++;
    });

    // $(window).on('load', function() {
    //   $('.search-results--placeholder').each(function() {
    //     resultTransition($(this), searchResultPlaceholder, 'hide-placeholder');
    //     searchResultPlaceholder++;
    //   });
    // });

    function resultTransition(searchResultItem, counter, transitionClass) {
      searchResultItem
        .css({
          transitionDelay: (counter * 0.1) + 's',
        })
        .addClass(transitionClass);
    }
  };
});
