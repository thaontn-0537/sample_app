class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.micropost.image_height,
                                        Settings.micropost.image_width]
  end
  scope :newest, ->{order(created_at: :desc)}
  scope :relate_post, ->(user_ids){where user_id: user_ids}
  validates :content, presence: true,
            length: {maximum: Settings.micropost.content.max_length}
  validates :image,
            content_type: {
              in: %w(image/jpeg image/gif image/png),
              message: I18n.t(".microposts.message.image_format")
            },
            size: {
              less_than: Settings.micropost.image_max_size.megabytes,
              message: I18n.t(".microposts.message.size_max")
            }
end
