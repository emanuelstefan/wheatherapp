require 'rails_helper'

RSpec.describe TemperatureConfig, :type => :model do
  subject {
    described_class.new(
      key: "something",
      min: 10,
      max: 20
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "validates min presence" do
    subject.key = nil
    expect(subject).to_not be_valid
  end
  
  it "validates min presence" do
    subject.min = nil
    expect(subject).to_not be_valid
  end

  it "validates max presence" do
    subject.max = nil
    expect(subject).to_not be_valid
  end

  it "validates key uniqueness" do
    TemperatureConfig.create(key: "something", min:1, max:2)
    expect(subject).to_not be_valid
  end

  it 'validates that min < max' do
    subject.max = 0
    expect(subject).to_not be_valid
  end

  it 'validates min size between -128 and 127' do
    subject.min = -200
    expect(subject).to_not be_valid
  end

  it 'validates max size between -128 and 127' do
    subject.min = 180
    expect(subject).to_not be_valid
  end
end