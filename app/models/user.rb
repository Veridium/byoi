class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable

  has_one :member, dependent: :destroy

  after_create :init_member

  def serializable_hash(options = nil) 
    super(options).merge(confirmed_at: confirmed_at).except("admin")
  end

  def init_member
    self.create_member!
  end
end
