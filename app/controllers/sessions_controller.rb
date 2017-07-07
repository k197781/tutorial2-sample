class SessionsController < ApplicationController
  def new

  end
  
  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
  		log_in(@user)
  		params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) # 記憶するかどうか
  		# redirect_to @user # user_controllerでなくても飛ばされる
  		redirect_back_or @user # 記憶したurl(store_location)またはデフォルトにリダイレクト
  	else
  		flash.now[:danger] = "Invalid email/password combination"
  		# flash.now[]で一回のみ表示　レンダリングが終わっているページで特別にフラッシュメッセージを表示することができる
  		render 'new' # 戻る
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end
end
