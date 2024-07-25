class User < ApplicationRecord
  VALID_EMAIL_REGEX = Regexp.new(Settings.value.valid_email)

  before_save :downcase_email

  validates :name, presence: true,
    length: {maximum: Settings.value.max_user_name}
  validates :email, presence: true,
    length: {maximum: Settings.value.max_user_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
