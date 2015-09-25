require 'spec_helper'

describe Habit do
  it { should validate_presence_of(:description) }
end
