namespace :intercom do
  desc "update intercom_user_id for pre existing users"
  task process_users: :environment do |t, args|

    log = ActiveSupport::Logger.new('log/intercom_process_users.log')
    log.info "Task started at #{Time.now}"

    Spree::User.where(intercom_user_id: nil).find_each do |user|
      if user.regenerate_intercom_user_id && Spree::Intercom::CreateUserService.new(user.id).create
        log.info "User ##{user.id} updated and record created on Intercom"
      else
        log.info "User ##{user.id} not updated and record not created on Intercom"
      end
    end

    log.info "Task stopped at #{Time.now}"
  end
end
