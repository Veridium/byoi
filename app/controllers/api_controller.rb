class ApiController < ApplicationController 
    before_action :authenticate_user
    skip_before_action :verify_authenticity_token
    private
      def authenticate_user
        true
      end
  
      def unauthorize
        head status: :unauthorized
        return false
      end
  end