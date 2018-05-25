class Spree::Intercom::Events::CreateUserService < Spree::Intercom::BaseService

  def initialize(id)
    @user = Spree::User.find_by(id: id)
    super()
  end

  def perform
    @intercom.events.create(event_data)
  end

  def event_data
    {
      event_name: 'created-user',
      created_at: @user.created_at.to_i,
      user_id: @user.intercom_user_id
    }
  end

  def register
    send_request
  end

end
