require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe "Questions", type: :system do
  let!(:user) { create(:user) }
  let!(:question) { build(:question) }

  before do
    driven_by(:rack_test)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする🚪'
  end

  it 'クイズの登録ができる' do
    visit new_question_path
    fill_in 'question[content]', with: question.content
    fill_in 'question[correct]', with: question.correct
    fill_in 'question[hint_1]', with: question.hint_1
    fill_in 'question[hint_2]', with: question.hint_2
    fill_in 'question[hint_3]', with: question.hint_3
    click_button 'クイズを作成する🚀'
    expect(page).to have_content(question.content)
  end

  it 'クイズが空欄の場合エラーが出る' do
    visit new_question_path
    fill_in 'question[correct]', with: question.correct
    fill_in 'question[hint_1]', with: question.hint_1
    fill_in 'question[hint_2]', with: question.hint_2
    fill_in 'question[hint_3]', with: question.hint_3
    click_button 'クイズを作成する🚀'
    expect(page).to have_content('登録に失敗しました')
    expect(page).to have_content('クイズを入力してください')
  end

  it '正解が空欄の場合エラーが出る' do
    visit new_question_path
    fill_in 'question[content]', with: question.content
    fill_in 'question[hint_1]', with: question.hint_1
    fill_in 'question[hint_2]', with: question.hint_2
    fill_in 'question[hint_3]', with: question.hint_3
    click_button 'クイズを作成する🚀'
    expect(page).to have_content('登録に失敗しました')
    expect(page).to have_content('答えを入力してください')
  end

  describe '自分が作問済み' do
    let!(:question) { create(:question, user: user) }

    it '一覧画面にクイズが表示されている' do
      visit questions_path
      expect(page).to have_content(question.content)
    end

    it '編集ができる' do
      visit question_path(question)
      click_link '編集する✏️'
      fill_in 'question[content]', with: '🚀🎯🐱🍙'
      click_button '保存する💾'
      expect(page).to have_content('🚀🎯🐱🍙')
    end
  end

  describe '他のユーザーが作問済み' do
    let!(:question) { create(:question) }

    it '回答ができる（正解）' do
      visit question_path(question)
      expect(page).to have_content(question.content)
      expect(page).to have_field('あなたの答え', disabled: false)
      fill_in 'あなたの答え', with: question.correct
      click_button 'お題を当てる🎯'
      expect(page).to have_content('正　解　🎉')
    end

    it '回答ができる(不正解)' do
      visit question_path(question)
      click_button 'お題を当てる🎯'
      expect(page).to have_content('😢 不正解でした！もう一度チャレンジしてみよう！')
    end

    it 'ギブアップができる' do
      visit question_path(question)
      click_link 'ギブアップ🏳️'
      expect(page).to have_content('🏳️ ギブアップしました！答えを確認しましょう。')
    end
  end
end