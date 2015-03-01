# Customising the editor to only have the basic toolbar
CKEDITOR.editorConfig = (config) ->
  config.language = 'en'
  config.width = '500'
  config.height = '500'
  config.toolbar_Basic = [
    { name: 'document',    items: [ 'Source' ] },
    { name: 'clipboard',   items: [ 'Cut','Copy','Paste','PasteText','PasteFromWord' ] },
    { name: 'edit',        items: [ 'Undo','Redo' ] }
    { name: 'styles',      items: [ 'Format'] },
    '/',
    { name: 'basicstyles', items: [ 'Bold','Italic','-', 'NumberedList','BulletedList','-','Outdent','Indent','Blockquote'] },
    { name: 'links',       items: [ 'Link','Unlink','Anchor' ] },
    { name: 'insert',      items: [ 'Image','Table', '-', 'HorizontalRule', '-', 'SpecialChar' ] },
  ]
  config.toolbar = 'Basic'
  true
