class Spree::Intercom::UserService < Spree::Intercom::BaseService

  def initialize(id)
    @user = Spree::User.find_by(id: id)
  end

  def process
    # to test failure
    int = Intercom::Client.new(token: nil)
    response = int.users.create(ActiveModelSerializers::SerializableResource.new(@user).serializable_hash)

    # to test success
    # intercom.users.create(ActiveModelSerializers::SerializableResource.new(@user).serializable_hash)
  end

  def create
    send_request
  end

  def update
    send_request
  end

end