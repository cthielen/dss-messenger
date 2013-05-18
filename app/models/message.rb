class Message < ActiveRecord::Base
  attr_accessible :impact_statement, :other_services, :purpose, :resolution, :sender_uid, :subject, :window_end, :window_start, :workaround, :classification_id, :modifier_id, :recipient_uids, :messenger_event_ids, :impacted_service_ids
  has_many :damages
  has_many :impacted_services, :through => :damages
  
  has_many :broadcasts
  has_many :messenger_events, :through => :broadcasts
  
  has_many :audiences
  has_many :recipients, :through => :audiences
  
  belongs_to :classification
  belongs_to :modifier

  # Filters to limit the result to specified criterion
  def self.filter(cl,mo,is,me)
    if cl
      self.where( classification_id: "#{cl}")
    elsif mo
      self.where( modifier_id: "#{mo}")
    elsif is
      joins(:damages).where( damages: { impacted_service_id: "#{is}"})
    elsif me
      joins(:broadcasts).where( broadcasts: { messenger_event_id: "#{me}"})
    else
      all
    end
  end
  
  def recipient_uids=(ids_str)
    ids_str.split(",").each do |r|
      recipient = Recipient.find_or_create_by_uid(r)
      self.recipients << recipient
    end
  end
  
  def as_json(options = {})
    {
      :id => self.id,
      :impact_statement => self.impact_statement,
      :other_services => self.other_services,
      :purpose => self.purpose,
      :resolution => self.resolution,
      :sender_uid => self.sender_uid,
      :subject => self.subject,
      :window_start => self.window_start,
      :window_end => self.window_end,
      :workaround => self.workaround,
      :classification_id => self.classification_id,
      :classification => self.classification,
      :modifier_id => self.modifier_id,
      :modifier => self.modifier,
      :recipients => self.recipients,
      :recipient_ids => self.recipients.pluck(:recipient_id),
      :recipient_uids => self.recipients.pluck(:recipient_id),
      :impacted_services => self.impacted_services,
      :impacted_service_ids => self.impacted_services.pluck(:impacted_service_id),
      :messenger_events => self.messenger_events,
      :messenger_event_ids => self.messenger_events.pluck(:messenger_event_id),
      :created_at => self.created_at.to_formatted_s(:short)
    }
    
  end
end
