var selectedSearchTab = function() {
  var search_tab = '';

  if ($('.search_tabs .keywords').hasClass('selected')) {
    search_tab = 'keywords';
  }
  if ($('.search_tabs .signs').hasClass('selected')) {
    search_tab = 'signs';
  }
  if ($('.search_tabs .advanced').hasClass('selected')) {
    search_tab = 'advanced';
  }

  return search_tab;
};

var search_analytics_string = function() {
  var queryValue = $('input#s').val();
  var handshapesValue = $('input#hs').val();
  var locationsValue = $('input#l').val();
  var locationGroupsValue = $('input#lg').val();
  var tagValue = $('select#tag').val();
  var usageValue = $('select#usage').val();

  queryValue = escape(queryValue);

  handshapesValue = handshapesValue.replace(/ /g, ',');
  locationsValue = locationsValue = $('input#l').val().replace(/ /g, ',');
  locationGroupsValue = locationGroupsValue.replace(/ /g, ',');

  var string = 'search_tab=' + selectedSearchTab()
               + ' ' + 'query=' + queryValue
               + ' ' + 'handshapes=' + handshapesValue
               + ' ' + 'locations=' + locationsValue
               + ' ' + 'location_groups=' + locationGroupsValue
               + ' ' + 'tag=' + tagValue
               + ' ' + 'usage=' + usageValue;

  return string;
};

/* exported ga_form_submission */
var ga_form_submission = function(event) {
  var form = this;
  var _gaq = _gaq || [];

  if (_gaq) {
    event.preventDefault();

    var search_string = search_analytics_string();
    _gaq.push(['_trackEvent', 'Search', 'Params', search_string]);

    setTimeout(function() {
      form.submit();
    }, 200);

    return false;
  }

  return true;
};

/* exported ga_link_submission */
var ga_link_submission = function(event) {
  event.preventDefault();
  var link = $(this);

  var destination = link.attr('href');
  if (typeof (destination) !== 'undefined' && destination !== '') {
    setTimeout(function() {
      window.location.href = destination;
    }, 100);
  }
};
