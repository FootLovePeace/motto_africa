class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :nickname, presence: true, length: { maximum: 20}   
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts       
  has_many :comments
 
  
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'は半角英数字混合で入力してください' 
end
