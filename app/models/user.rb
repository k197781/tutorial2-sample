class User < ApplicationRecord
	before_save { email.downcase! }
	validates :name, presence: true, length: { maximum: 140 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false },
				format: { with: VALID_EMAIL_REGEX }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }
	attr_accessor :remember_token

	# ハッシュ化
	def self.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
	end

	# ランダムなトークンを返す
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# データベースを更新
	def remember
	    self.remember_token = User.new_token
	    update_attribute(:remember_digest, User.digest(remember_token))
	end

	# ハッシュ化があってるか
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		# もし remember_tokenがなかったら戻る
	    BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# データベースを更新
	def forget
	    update_attribute(:remember_digest, nil)
	end
end
