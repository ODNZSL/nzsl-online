/**
 * This function 'polyfills' cross-origin file downloads. It does so by fetching
 * the file as a blob, then creating a a[download] with the blob URL and
 * clicking it, then removing it from the DOM.
 *
 * Since we have a CORS policy allowing fetches to our media bucket, this works
 * cross-origin, since after fetching, the blob is same-origin.
 *
 * It derives the filename to use as the basename of the href URL. This assumes
 * that the URL has a filename in it, rather than just a path name. If the
 * basename cannot be derived, 'file' is used as the filename.
 */
function initializeDownloadLinks() {
  $(document).on('click', '.download-link', function(evt) {
    evt.preventDefault();
    var link = this;
    var path_parts = new URL(link.href).pathname.split('/');
    var filename = path_parts[path_parts.length - 1] || 'file';

    // cache: no-store is present because Chrome is not including
    // the Origin header with the request without this set.
    fetch(link.href, {cache: 'no-store'})
        .then(function(response) {
          return response.blob();
        })
        .then(function(blob) {
          var a = document.createElement('a');
          a.download = filename;
          a.style.display = 'none';
          a.href = URL.createObjectURL(blob);
          a.addEventListener('click', function() {
            setTimeout(function() {
              URL.revokeObjectURL(a.href);
              a.remove();
            }, 1000);
          });
          document.body.append(a);
          a.click();
        });
  });
}

$(function() {
  initializeDownloadLinks();
});
