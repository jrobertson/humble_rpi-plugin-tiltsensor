Gem::Specification.new do |s|
  s.name = 'humble_rpi-plugin-tiltsensor'
  s.version = '0.2.0'
  s.summary = 'A Humble RPi plugin to detect movement using a tilt sensor.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/humble_rpi-plugin-tiltsensor.rb']
  s.add_runtime_dependency('rpi_pinin', '~> 0.1', '>=0.1.2')  
  s.add_runtime_dependency('chronic_duration', '~> 0.10', '>=0.10.6')
  s.signing_key = '../privatekeys/humble_rpi-plugin-tiltsensor.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/humble_rpi-plugin-tiltsensor'
end
