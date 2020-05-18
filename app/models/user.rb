class User < ApplicationRecord
  EMAIL_REGEX = Settings.VALID_EMAIL_REGEX
  USER_PARAMS = [:name, :email, :password, :password_confirmation].freeze

  validates :name, presence: true, length: {minimum: Settings.validation.min_name, maximum: Settings.validation.max_name}
  validates :email, presence: true, length: {maximum: Settings.validation.max_email}, uniqueness: true,
    format: {with: EMAIL_REGEX}
  
  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
