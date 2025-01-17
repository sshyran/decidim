# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # Tells/Extends time before inactivity warning or automatic logout.
  class TimeoutsController < Decidim::ApplicationController
    prepend_before_action :skip_timeout, only: :seconds_until_timeout

    def skip_timeout
      request.env["devise.skip_timeoutable"] = true
    end

    def seconds_until_timeout
      time_remaining = current_user ? ::Devise.timeout_in - (Time.current - Time.zone.at(user_session["last_request_at"])) : 0
      respond_to do |format|
        format.json { render json: { seconds_remaining: time_remaining.to_i }, status: :ok }
      end
    end

    # If user wants to continue session after inactivity warning.
    def heartbeat
      respond_to do |format|
        format.js
      end
    end
  end
end
