require 'rails_helper'

RSpec.describe User, type: :model do
  it '名前・アドレス・パスワードがあること' do
    user = build(:user)
    expect(user).to be_valid
    expect(user.errors).to be_empty
  end

  it 'メールはユニークであること' do
    user1 = create(:user)
    user2 = build(:user)
    user2.email = user1.email
    user2.valid?
    expect(user2.errors[:email]).to include('はすでに存在します')
  end

  it 'PWは6文字以上であること' do
    user = build(:user)
    user.password = 'abc'
    user.valid?
    expect(user.errors[:password]).to include('は6文字以上で入力してください')
  end

  it '名前は50文字以下であること' do
    user = build(:user)
    user.name = 'a' * 51
    user.valid?
    expect(user.errors[:name]).to include('は50文字以内で入力してください')
  end
end
