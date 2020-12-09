require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe "ユーザー新規登録" do
    context "新規登録がうまくいくとき" do
      it "全ての項目の入力が存在すれば登録できる" do
        expect(@user).to be_valid
      end
      it "nicknameが20文字以下であれば登録できる" do
        @user.nickname = "test"
        expect(@user).to be_valid
      end
      it "passwordが6文字以上であれば登録できる" do
        @user.password = "000aaa"
        @user.password_confirmation = "000aaa"
        expect(@user).to be_valid
      end
    end

    context "新規登録がうまくいかないとき" do
      it 'nicknameが空だと登録できない' do
        @user.nickname = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("ニックネームを入力してください")
      end
      it 'emailが空だと登録できない' do
        @user.email = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("メールアドレスを入力してください")
      end
      it "nicknameが21文字以上であれば登録できない" do
        @user.nickname = "abcdefghijklmnopqrstu"
        @user.valid?
        expect(@user.errors.full_messages).to include("ニックネームは20文字以内で入力してください")
      end
      it "重複したemailが存在する場合登録できない" do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("メールアドレスはすでに存在します")
      end   
      it 'emailに@を含めないと登録できない' do
        @user.email = "aaabbb"
        @user.valid?
        expect(@user.errors.full_messages).to include("メールアドレスは不正な値です")
      end
      it 'passwordが空だと登録できない' do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードを入力してください")
      end
      it "passwordが5文字以下であれば登録できない" do
        @user.password = "00000"
        @user.password_confirmation = "00000"
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードは6文字以上で入力してください")
      end
      it 'passwordが存在してもpassword_confirmationが一致しないと登録できない' do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end
      it "passwordは半角英数字混合でないと登録できない" do
        @user.password = "あいうえおか"
        @user.password_confirmation = "あいうえおか"
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードは半角英数字混合で入力してください")
      end
      it "passwordは数字だけでは登録できない" do
        @user.password = "000000"
        @user.password_confirmation = "000000"
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードは半角英数字混合で入力してください")
      end
      it "passwordは半角英字だけでは登録できない" do
        @user.password = "aaaaaa"
        @user.password_confirmation = "aaaaaa"
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードは半角英数字混合で入力してください")
      end
    end
  end
end
