require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).order(best: :desc, created_at: :desc).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
