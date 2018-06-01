class Spree::Intercom::Events::User::CreateService < Spree::Intercom::BaseService

  EVENT_NAME = 'created-account'

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
      created_at: @user.created_at.to_i,
      user_id: @user.intercom_user_id
    }
  end

end
