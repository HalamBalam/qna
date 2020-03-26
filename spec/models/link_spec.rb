require 'rails_helper'

RSpec.describe Link, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'validates url' do
    link = question.links.new(attributes_for(:link))
    expect(link).to be_valid

    link = question.links.new(attributes_for(:link, :invalid))
    expect(link).to_not be_valid
  end

  it 'recognizes gists' do
    link = question.links.new(attributes_for(:link, :gist))
    expect(link).to be_gist

    link = question.links.new(attributes_for(:link))
    expect(link).to_not be_gist  
  end
end
