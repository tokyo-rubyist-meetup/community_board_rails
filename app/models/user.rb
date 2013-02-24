class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  validates :name, presence: true
  has_many :owned_communities, class_name: :Community, foreign_key: :owner_id

  def to_s
    name.to_s
  end

  def remember_me?
    true
  end
end
