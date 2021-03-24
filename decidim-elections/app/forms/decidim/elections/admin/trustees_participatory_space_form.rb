# frozen_string_literal: true

module Decidim
  module Elections
    module Admin
      # This class holds a form to add users as trustees from Decidim's admin panel.
      class TrusteesParticipatorySpaceForm < Decidim::Form
        attribute :user_id, Integer

        validates :user_id, presence: true
        validate :unique_trustee_name

        def map_model(trustee)
          self.user_id = trustee.decidim_user_id
        end

        def user
          @user ||= current_organization.users.find_by(id: user_id)
        end

        def unique_trustee_name
          errors.add :base, :is_taken if Decidim::Elections::Trustee.joins(:user).exists?(name: user.name, decidim_users: { decidim_organization_id: current_organization.id })
        end
      end
    end
  end
end
