class Genre < ApplicationRecord
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: '人々' },
    { id: 3, name: '食事' },
    { id: 4, name: '暮らし' },
    { id: 5, name: 'ファッション' },
    { id: 6, name: 'スポーツ' },
    { id: 7, name: '文化' },
    { id: 8, name: '観光' },
    { id: 9, name: 'ビジネス' },
    { id: 10, name: '教育' },
    { id: 11, name: '歴史' },
    { id: 12, name: '経済' },
    { id: 13, name: '宗教' },
    { id: 14, name: '小ネタ' },
    { id: 15, name: 'その他' },
  ]

  include ActiveHash::Associations
  has_many :posts
end
