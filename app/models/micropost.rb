class Micropost < ApplicationRecord
  belongs_to :user

  delegate :name, to: :user, prefix: :user
  has_one_attached :image

  scope :by_created_at, -> { order(created_at: :desc) }
  scope :feed_by_user, -> user_id { where user_id: user_id  }

  MICROPOST_PARAMS = [:content, :image].freeze
  
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.validation.max_content}
  validates :image, content_type: { in: Settings.validation.image_format,
                                    message: I18n.t("micropost.format_image") },
                    size:         { less_than: Settings.validation.size_max.megabytes,
                                    message: I18n.t("micropost.size_max_image") }

  def display_image
    image.variant resize_to_limit: Settings.validation.resize_to_limit
  end
end
