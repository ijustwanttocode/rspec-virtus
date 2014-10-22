require "spec_helper"
require "virtus"

class DummyPost
  include Virtus.model

  attribute :title, String
  attribute :body, String
  attribute :comments, Array[String]
  attribute :greeting, String, default: 'Hello!'
  attribute :custom_greeting, String, default: ->(post, attr) { "Hello #{attr}" }
end

describe DummyPost do
  it { expect(described_class).to have_attribute(:title) }
  it { expect(described_class).to have_attribute(:body).of_type(String) }
  it { expect(described_class).to have_attribute(:comments).of_type(Array, member_type: String) }
  it { expect(described_class).to have_attribute(:greeting).of_type(String).with_default('Hello!') }
  it { expect(described_class).to have_attribute(:custom_greeting).of_type(String).with_default('Hello!') }
end
