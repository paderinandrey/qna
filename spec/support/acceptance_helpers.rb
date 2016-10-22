module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    within(".panel.panel-default.devise-bs") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end
end
