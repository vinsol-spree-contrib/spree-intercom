class Spree::Intercom::CreateUserService < Spree::Intercom::BaseService

  def initialize(id)
    @user = Spree::User.find_by(id: id)
    super()
  end

  def perform
    @intercom.users.create(user_data)
  end

  def user_data
    Spree::Intercom::UserSerializer.new(@user).serializable_hash
  end

  def create
    send_request

    if @response.success?
      Spree::Intercom::Events::CreateUserService.new(@user.id).register
    end
  end

end
