Pod::Spec.new do |s|
  s.name        = 'WTM'
  s.version     = '0.16'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://https://github.com/benoit-pereira-da-silva/Watt'
  s.summary     = 'A multimedia - hypermedia engine'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true
  s.source_files =  'WTM/**/*.{h,m}'
  s.public_header_files = 'WTM/**/*.h'
  s.dependency  'Watt', '~> 0.3' 
end
