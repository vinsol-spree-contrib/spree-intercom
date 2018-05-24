FactoryBot.define do

  factory :spree_user, class: 'Spree::User' do
    email { FFaker::Internet.safe_email }
    created_at { FFaker::Time.between(1.days.ago, Date.today) }
    last_sign_in_ip { FFaker::Internet.ip_v4_address }
    intercom_user_id { FFaker::Internet.password }
    password { FFaker::Internet.password }
    password_confirmation { "#{password}" }
  end

end
