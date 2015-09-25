require 'spec_helper'

describe Goal do
  it { should validate_presence_of(:description) }

  it { should have_many(:habits) }
end
