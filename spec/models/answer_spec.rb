require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer1) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }

  it { should belong_to :question }
  it { should validate_presence_of :body }

  it 'should be maximum one best answer' do
    answer1.best!
    expect(answer1).to be_best
    expect(answer2).not_to be_best

    answer2.best!
    answer1.reload
    expect(answer1).not_to be_best
    expect(answer2).to be_best   
  end
end
