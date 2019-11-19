class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable

  def serializable_hash(options = nil) 
    super(options).merge(confirmed_at: confirmed_at).except("admin")
  end
end
