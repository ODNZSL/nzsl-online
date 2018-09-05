# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    layout 'admin'

    def edit
      @user = current_user
    end

    def update_password
      @user = User.find(current_user.id)
      if @user.update(user_params)
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(@user)
        redirect_to admin_path
      else
        render 'edit'
      end
    end

    private

      def user_params
        params.require(:user).permit(:password, :password_confirmation)
      end
  end
end
