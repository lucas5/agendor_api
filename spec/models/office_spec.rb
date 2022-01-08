require "rails_helper"

RSpec.describe Office, type: :model do
  it { should have_many :agendas }
  it { should have_many :rooms }
end
