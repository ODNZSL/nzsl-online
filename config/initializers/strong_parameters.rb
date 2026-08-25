# frozen_string_literal: true

ActiveSupport.on_load(:active_record) { include ActiveModel::ForbiddenAttributesProtection }
