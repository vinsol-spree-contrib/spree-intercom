Spree::User.class_eval do

  has_secure_token :intercom_user_id

  validates :intercom_user_id, uniqueness: { case_sensitive: false }

  after_commit :create_user_on_intercom, on: :create
  after_commit :update_user_on_intercom, on: :update, if: :user_intercom_attributes_changed?

  def completed_orders_count
    orders.complete.count
  end

  private

    def create_user_on_intercom
      Spree::Intercom::CreateUserJob.perform_later(id)
    end

    def update_user_on_intercom
      Spree::Intercom::UpdateUserJob.perform_later(id)
    end

    def user_intercom_attributes_changed?
      [:email, :last_sign_in_ip].any? { |attribute| saved_changes.include?(attribute) }
    end

end
