Pod::Spec.new do |s|

  s.name        = 'Watt'
  s.version     = '1.33'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://https://github.com/benoit-pereira-da-silva/Watt'
  s.summary     = 'Watt'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/Watt.git',  :submodules => true }
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source_files =  'Watt','Watt/**/*.{h,m}'
  s.public_header_files = 'Watt/**/*.h'

  s.subspec 'WattPackager' do |ss|
      ss.description     = 'A module to extract, package transmit, download watt registry pool and bundles'
      ss.source_files =  'WattPackager/*.{h,m}'
      ss.public_header_files = 'WattPackager/*.h'
      ss.dependency 'SSZipArchive'
      #ss.dependency 'zipzap'
  end

  s.subspec 'WTM' do |ss|
      ss.description     = 'A multimedia - hypermedia engine built on Watt'
      ss.source_files =  'WTM/**/*.{h,m}'
      ss.public_header_files = 'WTM/**/*.h'
  end

  s.subspec 'WTMIOS' do |ss|
      ss.description   = 'Reusable WTM components for IOS'
      ss.ios.deployment_target = '6.0'
      ss.ios.source_files =  'WTMIOS/**/*.{h,m}'
      ss.ios.public_header_files = 'WTMIOS/**/*.h'
      ss.resource_bundles = {'WTMIOS'=>'WTMIOS/Resources/*.png'}
      ss.ios.frameworks ='UIKit'
      ss.osx.source_files = ''
      ss.osx.public_header_files =''
   end

end
