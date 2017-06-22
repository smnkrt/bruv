require "spec_helper"

RSpec.describe Bruv do
  it { expect(Bruv::VERSION).not_to be_nil }

  class DummyClass
    include Bruv
    attribute  :a
    attribute  :d, ->(d) { d.upcase }
    attributes :b, :c
  end

  let(:a) { 1 }
  let(:d) { "abc" }
  let(:b) { 2 }
  let(:c) { "3" }

  context "correct number of params provided" do
    subject { DummyClass.new(a, d, b, c) }
    it "generates readers and assigns variables properly", :aggregate_failures do
      expect(subject.a).to eq(a)
      expect(subject.d).to eq(d.upcase)
      expect(subject.b).to eq(b)
      expect(subject.c).to eq(c)
    end
  end

  context "number of params exceeds number of defined variables" do
    subject { DummyClass.new(a, d, b, c, "1") }
    it "generates readers and assigns variables properly", :aggregate_failures do
      message = "Number of arguments exceeds number of instance variables for: DummyClass"
      expect { subject }.to raise_error(Bruv::BruvArgumentError, message)
    end
  end
end
