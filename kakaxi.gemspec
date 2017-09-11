files = [
  'lib/kakaxi.rb',
  'lib/exception/invalid_credentials.rb',
  'lib/kakaxi/farm.rb', 'lib/kakaxi/device.rb', 'lib/kakaxi/client.rb']

data_file_names = ['base_data', 'data', 'humidity', 'rainfall', 'solar_radiation', 'temperature', 'timelapse']
data_file_names.each { |file| files << "lib/kakaxi/data/#{file}.rb" } 

Gem::Specification.new do |s|
  s.name          = 'kakaxi'
  s.version       = '0.0.0'
  s.date          = '2017-09-10'
  s.summary       = 'Library for calling kakaxi api by ruby'
  s.description   = 'Make it easy to use Kakaxi API by ruby'
  s.authors       = ['Naggi Goishi']
  s.email         = 'naggi@kakaxi.jp'
  s.files         = files
  s.homepage      = 'https://kakaxi-data.me/doc#v1-get'
  s.license       = 'MIT'
end

