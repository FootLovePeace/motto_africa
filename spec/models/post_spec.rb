require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post)
  end

  describe "新規投稿" do
    context "新規投稿がうまくいくとき" do
      it "全ての項目の入力が存在すれば投稿できる" do
        expect(@post).to be_valid  
      end
    end

    context "新規投稿がうまくいかないとき" do
      it "titleが空だと投稿できない" do
        @post.title = ""
        @post.valid?
        expect(@post.errors.full_messages).to include("Title can't be blank")
      end
      # it "titleが40字を超えると投稿できない" do
      #   @post.title = "あいうえおアイウエオあいうえおアイウエオあいうえおアイウエオあいうえおアイウエオあ"
      #   @post.valid?
      #   # expect(@post.errors.full_messages).to include("Title can't be blank")
      # end
      it "textが空だと投稿できない" do
        @post.text = ""
        @post.valid?
        expect(@post.errors.full_messages).to include("Text can't be blank")
      end
      it "country_idの選択が1だと投稿できない" do
        @post.country_id= 1
        @post.valid?
        expect(@post.errors.full_messages).to include("Country Select")
      end  
      it "genre_idの選択が1だと投稿できない" do
        @post.genre_id= 1
        @post.valid?
        expect(@post.errors.full_messages).to include("Genre Select")
      end 
      it "imageが空だと投稿できない" do
        @post.image = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("Image can't be blank")
      end 
      it "userが紐付いていないと投稿できない" do
        @post.user = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("User must exist")  
      end      
    end
  end
end
