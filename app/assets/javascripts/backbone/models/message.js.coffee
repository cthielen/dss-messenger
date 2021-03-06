class DssMessenger.Models.Message extends Backbone.Model
  paramRoot: 'message'

  defaults:
    subject: null
    impact_statement: null
    window_start: null
    window_end: null
    purpose: null
    resolution: null
    workaround: null
    other_services: null
    sender_uid: null
    closed: false

  validation:
    recipient_uids:
      required: true
      msg: "Please enter at least one recipient"
    subject:
      required: true
      msg: "Please enter message subject"
    impact_statement:
      required: true
      msg: "Please enter an impact statement"

  toJSON: () ->
    json = _.omit(this.attributes, 'updated_at','created_at','classification','modifier','recipients','impacted_services','pages','current','sender_name', 'created_at_in_words', 'recipient_count', 'send_status')
    json

  toFullJSON: () ->
    json = _.omit(this.attributes, 'updated_at')
    json
    

class DssMessenger.Collections.MessagesCollection extends Backbone.Collection
  model: DssMessenger.Models.Message
  url: '/messages'
