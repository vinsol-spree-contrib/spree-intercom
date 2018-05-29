class Spree::Intercom::Events::User::UpdateService < Spree::Intercom::BaseService

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
      event_name: 'user-updated',
      created_at: Time.current.to_i,
      user_id: @user.intercom_user_id
    }
  end

end
