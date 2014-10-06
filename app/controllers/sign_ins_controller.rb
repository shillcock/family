class SignInsController < ApplicationController
  skip_before_action :authorize, only: [:show]

  def show
  end
end
