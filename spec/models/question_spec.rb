require 'rails_helper'

RSpec.describe Question, type: :model do
  it '設定したすべてのバリデーションが機能しているか' do
    question = build(:question)
    expect(question).to be_valid
    expect(question.errors).to be_empty
  end

  it 'クイズに絵文字以外は登録できない' do
    question = build(:question)
    question.content = 'aaa'
    question.valid?
    expect(question.errors[:content]).to include('は絵文字のみで入力してください')
  end

  it '答えが空欄は登録できない' do
    question = build(:question)
    question.correct = nil
    question.valid?
    expect(question.errors[:correct]).to include('を入力してください')
  end
end
