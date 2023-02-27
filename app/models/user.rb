class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :books
  has_many :book_comments,dependent: :destroy
  has_many :favorites,dependent: :destroy

  has_many :relationships,class_name:"Relationship",foreign_key:"follower_id",dependent: :destroy
  has_many :reverse_of_relationships,class_name:"Relationship",foreign_key:"followed_id",dependent: :destroy

  has_many :followings,through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_one_attached :profile_image


  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end


  def following?(other_user)
    self.followings.include?(other_user)
  end

  def follow(other_user)
    self.following_relationships.create(following_id: other_user.id)
  end

  def unfollow(other_user)
    self.following_relationships.find_by(following_id: other_user.id).destroy
  end


end
