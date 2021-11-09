require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Osuny
  class Application < Rails::Application
    config.load_defaults 6.1

    config.time_zone = 'Europe/Paris'

    config.active_job.queue_adapter = :delayed_job

    config.active_storage.service_urls_expire_in = 1.hour

    config.sass.preferred_syntax = :sass

    config.i18n.available_locales = [:fr, :en]
    config.i18n.default_locale = :fr
    config.i18n.fallbacks = [::I18n.default_locale]
    config.i18n.enforce_available_locales = false
    config.i18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.yml"]

    config.internal_domains = ['@noesya.coop'].freeze

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        address: "smtp-relay.sendinblue.com",
        port: 587,
        user_name: ENV['SMTP_USER'],
        password: ENV['SMTP_PASSWORD'],
        authentication: :plain
    }

    config.action_view.sanitized_allowed_tags = [
      "a", "abbr", "acronym", "address", "b", "big", "blockquote", "br",
      "cite", "code", "dd", "del", "dfn", "div", "dl", "dt", "em",
      "h1", "h2", "h3", "h4", "h5", "h6", "hr", "i", "img", "ins", "kbd", "li", "ol",
      "p", "picture", "pre", "samp", "small", "source", "span", "strong", "sub", "sup", "tt", "u", "ul", "var"
    ]
    config.action_view.sanitized_allowed_attributes = [
      "abbr", "alt", "cite", "class", "datetime", "decoding", "height", "href", "loading",
      "name", "sizes", "src", "srcset", "style", "target", "title", "type", "width", "xml:lang"
    ]

    config.allowed_special_chars = '#?!,@$%^&*+£µ-'

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
