class Spree::Intercom::UserUpdationService < Spree::Intercom::BaseService

  def initialize(id)
    @user = Spree::User.find_by(id: id)
  end

  def process
    user = intercom.users.find(user_id: @user.intercom_user_id)
    user_data = ActiveModelSerializers::SerializableResource.new(@user).serializable_hash

    user_data.each do |key, value|
      user.public_send "#{key}=", value
    end

    intercom.users.save(user)
  end

  def call
    send_request
  end
end