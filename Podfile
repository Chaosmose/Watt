workspace 'Watt'
xcodeproj 'PlayerSample/PlayerSample.xcodeproj'

target :PlayerSample do
    platform :ios, '6.0'
    pod 'Watt', :path => './Watt.podspec'
	pod 'WattPackager', :path => './Watt.podspec'
	pod 'WTM', :path => './Watt.podspec'
	pod 'WTMIOS', :path => './Watt.podspec'
    xcodeproj 'PlayerSample/PlayerSample.xcodeproj'
    link_with ['PlayerSample','PlayerSample Tests','PlayerSampleFlexions']
end
