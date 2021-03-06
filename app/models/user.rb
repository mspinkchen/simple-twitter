class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  mount_uploader :avatar, AvatarUploader

  # 需要 app/views/devise 裡找到樣板，加上 name 屬性
  # 並參考 Devise 文件自訂表單後通過 Strong Parameters 的方法
  validates_presence_of :name
  validates_uniqueness_of :name
  # 加上驗證 name 不能重覆 (關鍵字提示: uniqueness)

  has_many :tweets, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet
  
  has_many :replies, dependent: :restrict_with_error

  #追蹤關係
  has_many :followships, dependent: :destroy
  #我追蹤的人
  has_many :followings, through: :followships

  #反向追蹤
  has_many :inversed_followships, class_name: "Followship", foreign_key: "following_id"
  #追蹤我的人
  has_many :followers, through: :inversed_followships, source: :user

  def admin?
    self.role == "admin"
  end
  
  def following?(user)
    self.followings.include?(user)
  end


end
