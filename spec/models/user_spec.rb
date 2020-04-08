require 'rails_helper'

RSpec.describe User, type: :model do

  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { expect(answer.user).to be_author(answer) }
  it { expect(user).not_to be_author(answer) }
  it { expect(question.user).to be_author(question) }
  it { expect(user).not_to be_author(question) }

end
