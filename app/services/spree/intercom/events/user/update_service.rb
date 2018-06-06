class Spree::Intercom::Events::User::UpdateService < Spree::Intercom::BaseService

  EVENT_NAME = 'updated-account'

  def initialize(id)
    @user = Spree::User.find_by(id: id)
    super()
  end

  def register
    send_request
  end

  def perform
    @intercom.events.create(event_data)
  end

  def event_data
    {
      event_name: EVENT_NAME,
      created_at: @user.updated_at.to_i,
      user_id: @user.intercom_user_id
    }
  end

end
