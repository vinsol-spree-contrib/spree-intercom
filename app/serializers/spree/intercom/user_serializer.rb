class Spree::Intercom::UserSerializer < ActiveModel::Serializer
  attributes :email, :name, :phone, :custom_attributes
  attribute :last_sign_in_ip, key: :last_seen_ip, if: :ip_address_present?
  attribute :created_at, key: :signed_up_at
  attribute :intercom_user_id, key: :user_id

  def address_present?
    object.bill_address.present?
  end

  def phone
    if address_present?
      object.bill_address.phone
    end
  end

  def name
    if address_present?
      "#{object.bill_address.first_name} #{object.bill_address.last_name}"
    end
  end

  def ip_address_present?
    object.last_sign_in_ip.present?
  end

  def custom_attributes
    {
      number_of_orders: object.completed_orders_count
    }
  end
end
