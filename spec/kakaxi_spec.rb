require 'spec_helper'

describe Kakaxi do
  let(:client) { Kakaxi::Client.new('YOUR_EMAIL', 'YOUR_PASSWORD') }

  it 'initialize success with valid' do
    expect(client.class).to eq Kakaxi::Client
  end

  it 'initialize success loading temps' do
    client.load_temps
    expect(client.temps.class).to eq Array
  end

  it 'initialize success loading humidities' do
    client.load_humidities
    expect(client.humidities.class).to eq Array
  end

  it 'initialize success loading solar radiations' do
    client.load_solar_radiations
    expect(client.solar_radiations.class).to eq Array
  end

  it 'initialize success loading rainfall' do
    client.load_rainfalls
    expect(client.rainfalls.class).to eq Array
  end

  it 'initialize success loading timelapse' do
    client.load_timelapses
    expect(client.timelapses.class).to eq Array
  end
end

