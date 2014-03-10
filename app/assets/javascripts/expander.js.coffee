#--
# Copyright (c) 2012 Patrick Howard Wiseman
#
# https://github.com/patrickwiseman/javascript_controls
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#--

#Setup global to track expander objects
exports = this
this.controls ||= new Object
this.controls.expanders ||= []
this.controls.find ||= (htmlAttribute, htmlAttributeValue) ->
  ret = null
  for expander in exports.controls.expanders
    if expander.fieldset.attr(htmlAttribute) == htmlAttributeValue
      ret = expander
  ret

#Setup any expanders
$ ->
  $("fieldset.expander").each ->
    exports.controls.expanders.push(new Expander(this,{}));
  for expander in exports.controls.expanders
    expander.initialize()

#To be called on a fieldset element with a legend
class Expander
  constructor: (fieldset_element, options = {}) ->
    #Dicitionary of configurables
    @bottom_class_name = "expander-bottom"
    @expanded_bottom_text = "Collapse Section"
    @collapsed_bottom_text = "Expand Section"
    @bottom_html = "<div class='#{@bottom_class_name}'></div>"
    @collapsed_class_name = 'expander-collapsed'
    @expanded_class_name = 'expander-expanded'
    @expanded_title_text = "Click to collapse"
    @collapsed_title_text = "Click to expand"
    @force_exclude_class_name = "expander-force-exclude"
    @force_include_class_name = "expander-force-include"

    #All the crucical elements
    @fieldset = $(fieldset_element)
    @options = options
    @bottom = $(@bottom_html)
    @fieldset.append(@bottom)
    @legend = @fieldset.children("legend:first")
    @bottom = @fieldset.children(".#{@bottom_class_name}:last")

    #The children is everything visible except:
    #  1. The first legend element of the expander
    #  2. The inserted bottom control
    @children = @fieldset.children("*:visible, br, .#{@force_include_class_name}")
    #@children.filter(".expander").children("*")
    @children = @children.not(@legend)
    @children = @children.not(@bottom)
    @children = @children.not(".#{@force_exclude_class_name}")

    #Wire together the click options
    @legend.click =>
      this.toggle()
    @bottom.click =>
      this.toggle()

  initialize: (options = {}) ->
    @options = $.extend({}, @options, options)

    #Set the initial state of the expander according to options, closed by default
    if @fieldset.attr("data-expander-open") != undefined && @fieldset.attr("data-expander-open") == 'true'
      this.expand()
    else
      this.collapse()

  toggle: ->
    @open = !@open
    if @open
      this.expand()
    else
      this.collapse()

  expand: ->
    @open = true
    @fieldset.removeClass(@collapsed_class_name)
    @fieldset.addClass(@expanded_class_name)
    @legend.attr('title', @expanded_title_text)
    @bottom.attr('title', @expanded_title_text)
    @bottom.html(@expanded_bottom_text)
    @children.show()

  collapse: ->
    @open = false
    @fieldset.removeClass(@expanded_class_name)
    @fieldset.addClass(@collapsed_class_name)
    @legend.attr('title', @collapsed_title_text)
    @bottom.attr('title', @collapsed_title_text)
    @bottom.html(@collapsed_bottom_text)
    @children.hide()