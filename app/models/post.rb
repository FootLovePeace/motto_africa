class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :country
  belongs_to :genre

  with_options presence: true do
    validates :title, length: { maximum: 40}   
    validates :text
    validates :image
  end   
  
  with_options numericality: { other_than: 1, message: 'を選択してください' } do
    validates :country_id
    validates :genre_id
  end
end
