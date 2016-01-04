require 'bcrypt'

class User < ActiveRecord::Base
  has_many :entries

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true

  def password=(password)
    self.password_hash = BCrypt::Password.create(password)
  end

  def password
    BCrypt::Password.new(self.password_hash)
  end
end
