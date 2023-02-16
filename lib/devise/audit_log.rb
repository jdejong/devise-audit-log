# frozen_string_literal: true

require "devise"
require "devise/audit-log/version"

module Devise
  module AuditLog
    mattr_accessor :test
    @@test = true

      def self.log(event, user, warden, env, options, success)
        env ||= warden.try(:env)
        warden ||= env["warden"] if env

        request = ActionDispatch::Request.new(env)

        ael = AuthenticationEventLog.new

        ael.event_type = event
        ael.user = user
        ael.ip = request.remote_ip if env
        ael.user_agent = request.user_agent if env
        ael.referrer = request.referrer if env
        ael.scope = options[:scope].to_s
        ael.strategy = AuditLog.warden_strategy(warden) if warden

        ael.success = success
        ael.failure_reason = options[:message].to_s if !ael.success

        ael.identity = user.try(:email) || request.params[ ael.scope ] && request.params[ ael.scope ][:email] || nil

        ael.action = "#{request.params[:controller]}##{request.params[:action]}" if request && env && request.params.has_key?(:controller)

        ael.save
      end


      def self.warden_strategy(warden_env)
        strategy = warden_env.env["omniauth.auth"]["provider"] if warden_env.env["omniauth.auth"]
        strategy ||= warden_env.winning_strategy.class.name.split("::").last.underscore if warden_env.winning_strategy
        strategy ||= "database_authenticatable"
        strategy
      end

      def self.login_event
        "LOGIN".freeze
      end

      def self.logout_event
        "LOGOUT".freeze
      end

      def self.login_failure_event
        "LOGIN FAILURE".freeze
      end

      def self.account_unlocked_event
        "ACCOUNT UNLOCKED".freeze
      end

      def self.account_locked_event
        "ACCOUNT LOCKED".freeze
      end

      def self.password_reset_event
        "PASSWORD RESET".freeze
      end

      def self.password_reset_sent_event
        "PASSWORD RESET SENT".freeze
      end

      def self.password_change_event
        "PASSWORD CHANGED".freeze
      end
  end

  self.on(:logout) do |val|
    AuditLog.log(AuditLog.logout_event, val.try(:[], :record), val.try(:[], :warden), nil, val.try(:[], :options), true)
  end

  self.on(:login) do |val|
    AuditLog.log(AuditLog.login_event, val.try(:[], :record), val.try(:[], :warden), nil, val.try(:[], :options), true)
  end

  self.on(:login_failure) do |val|
    AuditLog.log(AuditLog.login_failure_event, nil, nil, val.try(:[], :env), val.try(:[], :options), false)
  end

  self.on(:password_change) do |val|
    AuditLog.log(AuditLog.password_change_event, val.try(:[], :record), nil, nil, {}, true)
  end

  self.on(:password_reset_sent) do |val|
    AuditLog.log(AuditLog.password_reset_sent_event, val.try(:[], :record), nil, nil, {}, true)
  end

  self.on(:password_reset) do |val|
    AuditLog.log(AuditLog.password_reset_event, val.try(:[], :record), nil, nil, {}, true)
  end

  self.on(:account_locked) do |val|
    AuditLog.log(AuditLog.account_locked_event, val.try(:[], :record), nil, nil, {}, true)
  end

  self.on(:account_unlocked) do |val|
    AuditLog.log(AuditLog.account_unlocked_event, val.try(:[], :record), nil, nil, {}, true)
  end
end
