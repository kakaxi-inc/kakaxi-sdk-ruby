lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = 'kakaxi'
  s.version       = '0.0.3'
  s.date          = '2017-09-10'
  s.summary       = 'Library for calling kakaxi api by ruby'
  s.description   = 'Make it easy to use Kakaxi API by ruby'
  s.authors       = ['Naggi Goishi']
  s.email         = 'naggi@kakaxi.jp'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|pkg)/}) }
  s.homepage      = 'https://kakaxi-data.me/doc#v1-get'
  s.license       = 'MIT'
end

