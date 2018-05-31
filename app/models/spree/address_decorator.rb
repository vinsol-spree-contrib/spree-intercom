Spree::Address.class_eval do

  after_commit :update_user_on_intercom, if: :user_intercom_attributes_changed?

  private

    def update_user_on_intercom
      order = Spree::Order.find_by(bill_address_id: id)
      user = order.try(:user)
      return unless user.present?

      unless user.bill_address.present?
        user.persist_order_address(order)
      end

      Spree::Intercom::UpdateUserJob.perform_later(user.id)
    end

    def user_intercom_attributes_changed?
      [:phone, :firstname, :lastname].any? { |attribute| saved_changes.include?(attribute) }
    end

end
