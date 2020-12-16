require 'rails_helper'

RSpec.describe "記事投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.build(:post)
  end
  context "記事投稿ができるとき"do
    it "ログインしたユーザーは新規投稿できる" do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('投稿する')
      # 投稿ページに移動する
      visit new_post_path
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # フォームに情報を入力する
      fill_in "タイトル", with: @post.title
      fill_in "内容", with: @post.text
      select @post.country.name, from: "国名"
      select @post.genre.name, from: "ジャンル"
      attach_file("post[image]", image_path)
      # 投稿するとPostモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Post.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページには先ほど投稿した内容の記事が存在することを確認する（テキスト）
      expect(page).to have_content(@post_title)
      expect(page).to have_content(@post_country_id)
      expect(page).to have_content(@post_genre_id)
      # トップページには先ほど投稿した内容の記事が存在することを確認する（画像）
      expect(page).to have_content(@post_image)
    end
  end
  context '記事投稿ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('投稿する')
      # ユーザーログインページに移動する
      visit new_user_session_path
    end
  end
end

RSpec.describe "記事編集", type: :system do
  before do
    @post1 = FactoryBot.create(:post)
    @post2 = FactoryBot.create(:post)
  end
  context "記事編集ができるとき" do
    it "ログインしたユーザーは自分が投稿した記事の編集ができる" do
      # 記事1を投稿したユーザーでログインする
      sign_in(@post1.user)
      # トップページに記事詳細ページへ遷移するボタンがあることを確認する
      expect(page).to have_content("記事を読む")
      # 記事1詳細ページへ遷移する
      visit post_path(@post1.id)      
      # 記事1詳細ページに「編集」ボタンがあることを確認する
      expect(page).to have_content("編集")
      # 記事1の編集ページへ遷移する
      visit edit_post_path(@post1.id)      
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find("#post_title").value
      ).to eq @post1.title
      expect(
        find("#post_text").value
      ).to eq @post1.text
      expect(
        find("#post_country_id").value
      ).to eq "#{@post1.country_id}"
      expect(
        find("#post_genre_id").value
      ).to eq "#{@post1.genre_id}" 
      expect(
        find("#post_image").value
      ).to eq ""   
      # 編集で添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image2.png')                      
      # 投稿内容を編集する
      fill_in "タイトル", with: "#{@post1.title}+編集したタイトル"
      fill_in "内容", with: "#{@post1.text}+編集した内容" 
      select @post2.country.name, from: "国名"
      select @post2.genre.name, from: "ジャンル" 
      attach_file("post[image]", image_path)
      # 編集してもPostモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Post.count }.by(0)
      # 記事1詳細ページへ遷移する
      expect(current_path).to eq post_path(@post1.id)   
      # 記事1詳細ページには先ほど変更した内容の記事が存在することを確認する（テキスト）
      expect(page).to have_content("#{@post1.title}+編集したタイトル")
      expect(page).to have_content("#{@post1.text}+編集した内容")
      expect(page).to have_content(@post2_country_id)
      expect(page).to have_content(@post2_genre_id)
      # 記事1詳細ページには先ほど変更した内容の記事が存在することを確認する（画像）
      expect(page).to have_selector("img")
    end
  end
  context "記事編集ができないとき" do
    it "ログインしたユーザーは自分以外が投稿した記事の編集画面には遷移できない" do
      # 記事1を投稿したユーザーでログインする
      sign_in(@post1.user)
      # 記事2の詳細ページへ遷移する
      expect(page).to have_content("記事を読む")
      visit post_path(@post2.id)            
      # 記事2に「編集」ボタンがないことを確認する
      expect(page).to have_no_content("編集")
    end
    it "ログインしていないと記事の編集画面には遷移できない" do
      # トップページにいる
      visit root_path
      # 記事1の詳細ページへ遷移する
      expect(page).to have_content("記事を読む")
      visit post_path(@post1.id)
      # 記事1に「編集」ボタンがないことを確認する
      expect(page).to have_no_content("編集")
    end
  end
end

RSpec.describe "記事削除", type: :system do
  before do
    @post1 = FactoryBot.create(:post)
    @post2 = FactoryBot.create(:post)
  end
  context "記事削除ができるとき" do
    it "ログインしたユーザーは自らが投稿した記事の削除ができる" do
      # 記事1を投稿したユーザーでログインする
      sign_in(@post1.user)
      # 記事1の詳細ページへ遷移する
      expect(page).to have_content("記事を読む")
      visit post_path(@post1.id)              
      # 記事1の詳細ページに「削除」ボタンがあることを確認する
      expect(page).to have_content("削除")
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect{
        find_link('削除', href: post_path(@post1)).click
      }.to change { Post.count }.by(-1)      
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページには記事1の内容が存在しないことを確認する（テキスト）
      expect(page).to have_no_content("#{@post1.title}")
      # トップページには記事1の内容が存在しないことを確認する（画像）
      expect(page).to have_no_content(@post1.image)
    end
  end
  context "記事削除ができないとき" do
    it "ログインしたユーザーは自分以外が投稿した記事の削除ができない" do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@post1.user)
      # 記事2の詳細ページへ遷移する
      expect(page).to have_content("記事を読む")
      visit post_path(@post2.id)              
      # 記事2の詳細ページに「削除」ボタンが無いことを確認する
      expect(page).to have_no_content("削除")      
    end
    it "ログインしていないと記事の削除ボタンがない" do
      # トップページに移動する
      visit root_path
      # 記事1の詳細ページへ遷移する
      expect(page).to have_content("記事を読む")
      visit post_path(@post1.id)      
      # 記事1に「削除」ボタンが無いことを確認する
      expect(page).to have_no_content("削除")
    end
  end
end

RSpec.describe "記事詳細", type: :system do
  before do
    @post = FactoryBot.create(:post)
  end
  it "ログインしたユーザーは記事詳細ページに遷移してコメント投稿欄が表示される" do
    # ログインする
    sign_in(@post.user)
    # トップページに記事詳細ページへ遷移するボタンがあることを確認する
    expect(page).to have_content("記事を読む")
    # 記事詳細ページへ遷移する
    visit post_path(@post.id) 
    # 詳細ページに記事の内容が含まれている
    expect(page).to have_content("#{@post_title}")
    expect(page).to have_content("#{@post_text}")
    expect(page).to have_content(@post_country_id)
    expect(page).to have_content(@post_genre_id)
    expect(page).to have_content(@post_image)
    # コメント用のフォームが存在する
    expect(page).to have_selector "form"
  end
  it "ログインしていない状態で記事詳細ページに遷移できるもののコメント投稿欄が表示されない" do
    # トップページに移動する
    visit new_user_session_path
    fill_in "メールアドレス", with: @post.user.email
    fill_in "パスワード", with: @post.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path    
    # トップページに記事詳細ページへ遷移するボタンがあることを確認する
    expect(page).to have_content("記事を読む")
    # 記事詳細ページへ遷移する
    visit post_path(@post.id) 
    # 詳細ページに記事の内容が含まれている
    expect(page).to have_content("#{@post_title}")
    expect(page).to have_content("#{@post_text}")
    expect(page).to have_content(@post_country_id)
    expect(page).to have_content(@post_genre_id)
    expect(page).to have_content(@post_image)
    # フォームが存在しないことを確認する
    expect(page).to have_no_selector "コメント"
  end
end