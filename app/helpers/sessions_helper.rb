module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
	    # ユーザIDのハッシュ化
    	cookies.permanent[:remember_token] = user.remember_token
    	# ユーザの持つトークン
    	# cookies[:remember_token], cookies[:user_id]
    end

	def current_user
		#@current_user ||= User.find_by(id: session[:user_id])
		
		# session[:user_id] がなければ nil を返す
		#if @current_user.nil?
  		#@current_user = User.find_by(id: session[:user_id])
		#else
  		#@current_user
		#end

		if (user_id = session[:user_id])
		# ユーザがセッションIDを持つ
	    	@current_user ||= User.find_by(id: user_id)
	    elsif (user_id = cookies.signed[:user_id])
	    # ユーザが記憶トークンを持つ
	    	user = User.find_by(id: user_id)
	    	if user && user.authenticated?(cookies[:remember_token])
	    	# 記憶トークンがデータベースにもある
	    		log_in user
	    		@current_user = user
	    	end
	    end
	end

	def logged_in?
		!current_user.nil?
	end

	# 記憶トークン(データベース，ユーザ)を削除
	def forget(user)
	    user.forget
	    cookies.delete(:user_id)
	    cookies.delete(:remember_token)
	end

	def log_out
		forget(current_user)
		# 記憶トークンの削除
		session.delete(:user_id)
		# セッションIDの削除
  		@current_user = nil
	end
	
end
