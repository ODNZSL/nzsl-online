/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	config.language = 'en';
  config.height = '400px';
  config.width  = '400px';
  config.toolbar = [
    ['Source'],
    ['Cut','Copy','Paste','PasteText','PasteFromWord'],
    ['Undo','Redo'],
    ['Format'],['Bold','Italic','-',
    'NumberedList','BulletedList','-',
    'Outdent','Indent','Blockquote'],
    //'CreateDiv','-',
    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
    ['Link','Unlink','Anchor'],
    ['Image','Embed','Table','-','HorizontalRule','-','SpecialChar']
  ];
  config.specialChars = [
    // AEIOU macrons
    '&#256;','&#274;','&#298;','&#332;','&#362;',
    // aoiou macrons
    '&#257;','&#275;','&#299;','&#333;','&#363;',
    '&Agrave;','&Aacute;','&Acirc;','&Atilde;','&Auml;','&Aring;','&AElig;',
    '&Ccedil;',
    '&Egrave;','&Eacute;','&Ecirc;','&Euml;',
    '&Igrave;','&Iacute;','&Icirc;','&Iuml;',
    '&ETH;','&Ntilde;',
    '&Ograve;','&Oacute;','&Ocirc;','&Otilde;','&Ouml;','&Oslash;','&OElig;',
    '&Ugrave;','&Uacute;','&Ucirc;','&Uuml;',
    '&THORN;','&#372;','&#374','&Yacute;',
    '&agrave;','&aacute;','&acirc;','&atilde;','&auml;','&aring;','&aelig;',
    '&ccedil;',
    '&egrave;','&eacute;','&ecirc;','&euml;',
    '&igrave;','&iacute;','&icirc;','&iuml;',
    '&eth;','&ntilde;',
    '&ograve;','&oacute;','&ocirc;','&otilde;','&ouml;','&oslash;','&oelig;',
    '&szlig;',
    '&ugrave;','&uacute;','&ucirc;','&uuml;','&uuml;',
    '&thorn;','&#373','&yacute;','&yuml;','&#375;',
    '&lsquo;','&rsquo;','&ldquo;','&rdquo;',
    '&ndash;','&mdash;',
    '&cent;','&pound;','&curren;','&yen;','&euro;',
    '&copy;','&reg;','&trade;',    
    '&deg;','&asymp;','&plusmn;','&times;','&divide;','&sup2;','&sup3;',
    '&frac14;','&frac12;','&frac34;',
    '&hellip;',
    '&bull;','&rarr;','&rArr;','&hArr;'
  ]
};
