class SessionsController < ApplicationController
  def new

  end
  
  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		flash[:success] = ""
  		log_in(user)
  		redirect_to user # user_controllerでなくても飛ばされる
  	else
  		flash.now[:danger] = "Invalid email/password combination"
  		# flash.now[]で一回のみ表示　レンダリングが終わっているページで特別にフラッシュメッセージを表示することができる
  		render 'new' # 戻る
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end
end
