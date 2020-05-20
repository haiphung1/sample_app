class User < ApplicationRecord
  attr_accessor :remember_token

  EMAIL_REGEX = Settings.VALID_EMAIL_REGEX
  USER_PARAMS = [:name, :email, :password, :password_confirmation].freeze

  validates :name, presence: true, length: {minimum: Settings.validation.min_name, maximum: Settings.validation.max_name}
  validates :email, presence: true, length: {maximum: Settings.validation.max_email}, uniqueness: true,
    format: {with: EMAIL_REGEX}
  
  has_secure_password

  before_save :downcase_email

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
             
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
