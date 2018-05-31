namespace :intercom do
  desc "update intercom_user_id for pre existing users"
  task process_users: :environment do |t, args|

    log = ActiveSupport::Logger.new('log/intercom_process_users.log')
    log.info "Task started at #{Time.now}"

    Spree::User.where(intercom_user_id: nil).find_each do |user|
      if user.regenerate_intercom_user_id
        log.info "User ##{user.id} updated"
      else
        log.info "User ##{user.id} could not be updated"
      end
    end

    log.info "Task stopped at #{Time.now}"
  end
end
