module ActiveAdmin
  class ManagedResource < ActiveRecord::Base
    self.table_name = "active_admin_managed_resources"

    has_many :permissions, dependent: :destroy
    validates :class_name, presence: true
    validates :action, presence: true

    def const
      @const ||= class_name.try(:safe_constantize)
    end

    def active?
      !const.nil?
    end

    def for_active_admin_page?
      class_name == "ActiveAdmin::Page"
    end

    def self.ransackable_attributes(auth_object = nil)
      ["action", "class_name", "created_at", "id", "id_value", "name", "updated_at"]
    end

    class << self
      def reload
        ActiveAdmin::PermissionReloader.reload
      end
    end
  end
end
