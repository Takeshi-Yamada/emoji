require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'ユーザー登録' do
    visit new_user_registration_path
    user = build(:user)
    fill_in '名前', with: user.name
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    fill_in 'パスワード（確認）', with: user.password
    click_button '登録する'
    expect(page).to have_content('アカウント登録が完了しました。')
  end

  let!(:user) { create(:user) }

  it 'ログイン処理' do
    visit new_user_session_path
    expect(page).to have_field('メールアドレス', wait: 5)
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする🚪'
    expect(page).to have_content('ログインしました。')
  end

  describe 'ログイン済み', js: true do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログインする🚪'
    end

    it 'マイページ遷移' do
      visit profile_path(user)
      expect(page).to have_content("さんのマイページ")
    end

    it 'ログアウト処理' do
      visit root_path
      click_link 'ログアウト', match: :first
      expect(page).to have_content('ログアウトしました。')
    end
  end
end
