exports = this
this.controls ||= new Object
this.controls.find ||= (htmlAttribute, htmlAttributeValue) ->
  ret = null
  for expander in exports.controls.expanders
    if expander.fieldset.attr(htmlAttribute) == htmlAttributeValue
      ret = expander
  ret
