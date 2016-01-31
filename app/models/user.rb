class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :reviews

	def first_name
		#TODO hack to get working
		'John'
	end

	def last_name
		#TODO hack to get working
		'Smith'
	end
end
