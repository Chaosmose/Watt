workspace 'Watt'
xcodeproj 'PlayerSample/PlayerSample.xcodeproj'

target :PlayerSample do
    platform :ios, '6.0'
    pod 'Watt', :path => 'Watt.podspec'
	pod 'Watt/WattPackager'
	pod 'Watt/WTM'
	pod 'Watt/WTMIOS'
    
    pod 'TRVSMonitor'
    xcodeproj 'PlayerSample/PlayerSample.xcodeproj'
    link_with ['PlayerSample','PlayerSample Tests','PlayerSampleFlexions']
end
