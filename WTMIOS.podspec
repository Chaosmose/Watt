Pod::Spec.new do |s|
  s.name        = 'WTMIOS'
  s.version     = '0.3'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://https://github.com/benoit-pereira-da-silva/Watt'
  s.summary     = 'Reusable WTM components for IOS'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '6.0'
  s.requires_arc = true
  s.source_files =  'WTMIOS/**/*.{h,m}'
  s.public_header_files = 'WTMIOS/**/*.h'
  s.resources = 'wiosSound.bundle/*.*'
  s.preserve_paths = 'wiosSound.bundle/*'
  s.dependency  'Watt', '~> 0.3'
  s.dependency  'WTM', '~> 0.3'
end
