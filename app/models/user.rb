class User < ApplicationRecord
  has_secure_password

  before_save :downcase_email

  validates :email, presence: true, uniqueness: true, format: /@/
  # validates :password, presence: true, length: { minimum: 6 }

  def downcase_email
    self.email = email.delete(' ').downcase
  end
end
