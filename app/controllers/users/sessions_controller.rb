class Users::SessionsController < Devise::SessionsController
  def guest
    user = User.guest
    sign_in(:user, user)

    respond_to do |format|
      format.html { redirect_to authenticated_root_path, notice: "Signed in as guest.", status: :see_other }
      format.turbo_stream { redirect_to authenticated_root_path, notice: "Signed in as guest.", status: :see_other }
    end
  end
end
