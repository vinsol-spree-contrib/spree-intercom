class Spree::Intercom::UserSerializer < ActiveModel::Serializer

  attributes :email, :name, :phone
  attribute :last_sign_in_ip, key: :last_seen_ip
  attribute :created_at, key: :signed_up_at
  attribute :intercom_user_id, key: :user_id
  attribute :completed_orders_count, key: :number_of_orders

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

end
