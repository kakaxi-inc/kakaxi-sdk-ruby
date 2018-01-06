require 'spec_helper'

describe Kakaxi do
  let(:client) { Kakaxi::Client.new('nespresso+admin@kakaxi.jp', 'coffee1234') }

  it 'initialize success with valid' do
    expect(client.class).to eq Kakaxi::Client
  end
end

