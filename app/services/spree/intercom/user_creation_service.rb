class Spree::Intercom::UserCreationService < Spree::Intercom::BaseService

  def initialize(id)
    @user = Spree::User.find_by(id: id)
  end

  def process
    intercom.users.create(ActiveModelSerializers::SerializableResource.new(@user).serializable_hash)
  end

  def call
    send_request
  end
end