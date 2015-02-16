Pod::Spec.new do |s|
  s.name        = 'Watt'
  s.version     = '1.40'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://github.com/benoit-pereira-da-silva/Watt'
  s.summary     = 'Watt is a data persistency framework'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true
  
  s.source_files =  'Classes/Watt/*.{h,m}'
  s.default_subspec = 'WattBase'

s.subspec 'WattBase' do | base|
	base.description     = 'A module to extract, package transmit, download watt registry pool and bundles'
    base.source_files =  'Classes/Watt/Core/*.{h,m}','Classes/Watt/Categories/*.{h,m}','Classes/Watt/Generated/*.{h,m}'
end

s.subspec 'WattPackager' do |packager|
	packager.description     = 'A module to extract, package transmit, download watt registry pool and bundles'
    packager.source_files =  'Classes/WattPackager/*.{h,m}'
    packager.dependency 'SSZipArchive'
end
  
s.subspec 'WTM' do |wtm|
    wtm.description     = 'A multimedia - hypermedia engine built on Watt'
    wtm.source_files =  'Classes/WTM/**/*.{h,m}'
end
  
s.subspec 'WTMIOS' do |mios|
    mios.description   = 'Reusable WTM components for IOS'
    mios.ios.source_files =  'Classes/WTMIOS/*.{h,m}','Classes/WTMIOS/Categories/*.{h,m}'
    mios.resource_bundles = {'WTMIOS'=>'Classes/WTMIOS/Resources/*.png'}
    mios.ios.frameworks ='UIKit'
    mios.osx.source_files = ''
end

end