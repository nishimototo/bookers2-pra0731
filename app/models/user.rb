class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, uniqueness: true, length: {in: 2..20 }
  validates :introduction, length: {maximum: 50}
  attachment :profile_image

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

  def followed_by?(user)
    passive_relationships.where(following_id: user.id).exists?
  end

  def self.looks(word, search)
    if search == "perfect_match"
      User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      User.where("name LIKE?", "#{word}%")
    elsif search == "backword_match"
      User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      User.where("name LIKE?", "%#{word}%")
    else
      User.all
    end
  end
end
