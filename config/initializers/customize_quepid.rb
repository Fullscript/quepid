# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# This file checks for various customization options passed in as environment
# variables.

bool = ActiveRecord::Type::Boolean.new

# == Quepid Version
# What version of Quepid is this?
#
Rails.application.config.quepid_version = ENV.fetch('QUEPID_VERSION', 'UNKNOWN')

# == Quepid Default Scorer
# New users to Quepid need to have a recommended scorer to use, which they can then
# override to their own preferred scorer, either one of the defaults shipped with Quepid
# or a custom scorer.
#
Rails.application.config.quepid_default_scorer = ENV.fetch('QUEPID_DEFAULT_SCORER', 'AP@10')

# == Email Marketing Permission
# To comply with GDPR, and be a good citizen, the hosted version of Quepid asks
# if they are willing to receive Quepid related updates via email.  This feature
# isn't useful to private installs, so this controls the display.
#
Rails.application.config.email_marketing_mode = bool.deserialize(ENV.fetch('EMAIL_MARKETING_MODE', false))

# == Cookies Policy URL
# To comply with GDPR, and be a good citizen, the hosted version of Quepid asks
# about cookies and provides a link to the cookies policy. This feature
# isn't useful to private installs, so this controls the display.
#
Rails.application.config.cookies_url = ENV.fetch('COOKIES_URL', nil)

# == Privacy Policy URL
# To comply with GDPR, and be a good citizen, the hosted version of Quepid links
# to a privacy policy. This feature isn't useful to private installs, so this
# controls the display.
#
Rails.application.config.privacy_url = ENV.fetch('PRIVACY_URL', nil)

# == Hosted App.quepid.com T&C's
# Users of the free hosted app.quepid.com are asked to agree to certain terms &
# conditions. This feature isn't useful to private installs, so this
# controls the display.
#
Rails.application.config.terms_and_conditions_url = ENV.fetch('TC_URL', nil)

# == Enable signup
# This parameter controls whether or not signing up via the UI is enabled.
Rails.application.config.signup_enabled = bool.deserialize(ENV.fetch('SIGNUP_ENABLED', true))

# == Communal Scorers Only
# Users can normally create custom scorers which run embedded javascript, this is a potential
# security flaw as malicious javascript could be entered. This setting restricts users to
# communal scorers only, which are controlled by admins.
#
Rails.application.config.communal_scorers_only = bool.deserialize(ENV.fetch('COMMUNAL_SCORERS_ONLY', false))

# == What Email Provider to Use
# You can send emails to users using either the Postmark Saas service by setting this to POSTMARK, or
# you can send using traditional SMTP server by setting this to SMTP.  Leave it blank and there is
# no email provider.
Rails.application.config.email_provider = ENV.fetch('EMAIL_PROVIDER', '')

# == Email Address of the Sender of Emails
# When Quepid sends emails to users, what is the email address of the sender?
Rails.application.config.email_sender = ENV.fetch('EMAIL_SENDER', '')

# == Query List Sortable
# See https://github.com/o19s/quepid/issues/272 for a bug in expand/collapse that some setups experience.
# This lets you disable the sorting if you experience the bug.
#
Rails.application.config.query_list_sortable = bool.deserialize(ENV.fetch('QUERY_LIST_SORTABLE', true))

# == OAuth Settings =
# We currently only support these two OAuth providers.
Rails.application.config.google_client_id = ENV.fetch('GOOGLE_CLIENT_ID', '')
Rails.application.config.google_client_secret = ENV.fetch('GOOGLE_CLIENT_SECRET', '')

Rails.application.config.keycloak_realm = ENV.fetch('KEYCLOAK_REALM', '')
Rails.application.config.keycloak_site = ENV.fetch('KEYCLOAK_SITE', '')

# == Google Analytics
# To enable Google Analytics, set this environment variable.
Rails.application.config.google_analytics = ENV.fetch('QUEPID_GA', '')
Rails.application.config.google_analytics_enabled = Rails.application.config.google_analytics.present?

# == Domain Quepid is Running Under
# Certain features, like sending emails and Google Analytics require you to set the domain that Quepid
# is set up under.
Rails.application.config.quepid_domain = ENV.fetch('QUEPID_DOMAIN', '')

# == Disable redirecting to match the TLS setting
Rails.application.config.redirect_to_match_search_engine_tls = ENV.fetch('REDIRECT_TO_MATCH_SEARCH_ENGINE_TLS', true)

# == Prophet Analytics Control
# Prophet tells you interesting things about time series curves and is used on the homepage.
# It may consume too much memory for your environment, and you may need to disable it.
Rails.application.config.quepid_prophet_analytics = bool.deserialize(ENV.fetch('QUEPID_PROPHET_ANALYTICS', true))
