require 'rails_helper'

RSpec.describe User, type: :model do

  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { expect(answer.user.is_author?(answer)).to be true }
  it { expect(user.is_author?(answer)).to be false }
  it { expect(question.user.is_author?(question)).to be true }
  it { expect(user.is_author?(question)).to be false }

end
