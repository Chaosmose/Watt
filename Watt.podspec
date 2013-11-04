Pod::Spec.new do |s|
  s.name        = 'Watt'
  s.version     = '0.15'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://https://github.com/benoit-pereira-da-silva/Watt'
  s.summary     = 'Watt'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true
  s.source_files =  'Watt','Watt/**/*.{h,m}'
  s.public_header_files = 'Watt/**/*.h'
  s.dependency 'SSZipArchive','~> 0.2.2'
  s.ios.dependency 'SVProgressHUD'
end
