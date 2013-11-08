Pod::Spec.new do |s|
  s.name        = 'WattPackager'
  s.version     = '0.01'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://https://github.com/benoit-pereira-da-silva/Watt'
  s.summary     = 'A module to extract, package transmit, download watt registry pool and bundles'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '6.1'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true
  s.source_files =  'WattPackager/*.{h,m}'
  s.public_header_files = 'WattPackager/*.h'
  s.dependency  'Watt', '~> 0.23'
  s.dependency   'WTM', '~> 0.17'
  s.dependency  'AFNetworking','~>2.0.1'
end