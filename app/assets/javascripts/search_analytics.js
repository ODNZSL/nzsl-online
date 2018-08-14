var search_analytics_string = function() {
  /* Tabs, query string, etc, from search box in header. */

  var search_tab = '';

  if ($('.search_tabs .keywords').hasClass('selected'))
  { search_tab = 'keywords'; }
  if ($('.search_tabs .signs').hasClass('selected'))
  { search_tab = 'signs'; }
  if ($('.search_tabs .advanced').hasClass('selected'))
  { search_tab = 'advanced'; }

  var query_val = $('input#s').val();

  var handshapes_val = $('input#hs').val();
  var locations_val = $('input#l').val();
  var location_groups_val = $('input#lg').val();

  var tag_val = $('select#tag').val();
  var usage_val = $('select#usage').val();

  query_val = escape(query_val);

  handshapes_val = handshapes_val.replace(/ /g, ',');
  locations_val = locations_val = $('input#l').val().replace(/ /g, ',');
  location_groups_val = location_groups_val.replace(/ /g, ',');

  var string = 'search_tab='+search_tab+
               ' '+'query='+query_val+
               ' '+'handshapes='+handshapes_val+
               ' '+'locations='+locations_val+
               ' '+'location_groups='+location_groups_val+
               ' '+'tag='+tag_val+
               ' '+'usage='+usage_val;

  return string;
};

var ga_form_submission = function(event) {
  var form = this;

  if (_gaq) {
    event.preventDefault();

    var search_string = search_analytics_string();
    _gaq.push(['_trackEvent', 'Search', 'Params', search_string]);

    setTimeout(function() { form.submit(); }, 200);

    return false;
  }

  return true;
};

var ga_link_submission = function(event) {
  event.preventDefault();
  var link = $(this);

  var dest = link.attr('href');
  if (typeof(dest) !== 'undefined' && dest !== '') {
    setTimeout(function(){ window.location.href = dest; }, 100);
  }
};
