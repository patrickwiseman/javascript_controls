#Setup global to track expander objects
exports = this
this.controls ||= new Object
this.controls.expanders ||= []

#Setup any expanders
$ ->
  $("fieldset.expander").each ->
    exports.controls.expanders.push(new Expander(this,{}));

#To be called on a fieldset element with a legend
class Expander
  constructor: (fieldset_element, options = {}) ->
    @fieldset = $(fieldset_element)
    @legend = @fieldset.children("legend").first()
    @children = @fieldset.children("*:visible,.expander-image-fix").filter(":not(legend)")
    @collapsed_css_class_name = 'expander-collapsed'
    @expanded_css_class_name = 'expander-expanded'
    
    if @fieldset.attr("data-expander-open") != undefined
      this.expand()
    else
      this.collapse()
    
    @legend.click (eventObj) =>
      this.toggle()

  toggle: ->
    @open = !@open
    if @open
      this.expand()
    else
      this.collapse()

  expand: ->
    @open = true
    @legend.removeClass(@collapsed_css_class_name)
    @legend.addClass(@expanded_css_class_name)
    @children.show()

  collapse: ->
    @open = false
    @legend.removeClass(@expanded_css_class_name)
    @legend.addClass(@collapsed_css_class_name)
    @children.hide()