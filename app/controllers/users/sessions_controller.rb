class Users::SessionsController < Devise::SessionsController
  def guest
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "Signed in as guest."
  end
end
