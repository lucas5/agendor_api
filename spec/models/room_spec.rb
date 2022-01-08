require "rails_helper"

RSpec.describe Room, type: :model do
  it { should belong_to :office }
  it { should have_many :agendas }
end
