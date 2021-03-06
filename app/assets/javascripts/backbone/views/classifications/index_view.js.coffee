DssMessenger.Views.Classifications ||= {}

class DssMessenger.Views.Classifications.IndexView extends Backbone.View
  template: JST["backbone/templates/classifications/index"]

  events:
    "change"          : "filter"

  tagName: "select"
  
  initialize: () ->
    DssMessenger.classifications.bind('reset', @addAll)
    _.defer =>
      @$el.selectpicker()
      @$el.selectpicker 'val', DssMessenger.filterClassification if DssMessenger.filterClassification > 0

  addAll: () =>
    @$el.append('<option></option>')
    DssMessenger.classifications.each(@addOne)

  addOne: (classifications) =>
    view = new DssMessenger.Views.Classifications.ClassificationsView({model : classifications})
    @$el.append(view.render().el)

  render: =>
    @$el.addClass('selectpicker').html(@template(DssMessenger.classifications.toJSON() ))
    @addAll()

    return this

  filter: (e) ->
    e.stopPropagation()
    DssMessenger.filterClassification = Number @$el.val()
    DssMessenger.current = 1

    $('.overlay,.loading').removeClass('hidden')

    DssMessenger.messages.fetch
      timeout: 30000 # 30 seconds
      data:
        page: DssMessenger.current,
        cl: DssMessenger.filterClassification if DssMessenger.filterClassification > 0,
        mo: DssMessenger.filterModifier if DssMessenger.filterModifier > 0,
        is: DssMessenger.filterService if DssMessenger.filterService > 0,

      success: (messages) =>
        if messages.length > 0
          DssMessenger.pages = messages.first().get('pages')
          DssMessenger.current = messages.first().get('current')
        else
          DssMessenger.pages = 1
          DssMessenger.current = 1
          
        if DssMessenger.filterClassification == DssMessenger.filterModifier == DssMessenger.filterService
          $("#reset-filters").addClass("hidden")
        else
          $("#reset-filters").removeClass("hidden")

      error: (messages, response) ->
        console.log "#{response.status}."
        $('.error').removeClass('hidden')
  
    return true
