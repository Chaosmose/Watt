workspace 'Watt'
xcodeproj 'PlayerSample/PlayerSample.xcodeproj'

target :PlayerSample do
    platform :ios, '7.0'
    pod 'Watt', :path => 'Watt.podspec'
    pod 'Watt/WattPackager', :path => 'Watt.podspec'
    pod 'Watt/WTM', :path => 'Watt.podspec'
    pod 'Watt/WTMIOS', :path => 'Watt.podspec'
    xcodeproj 'PlayerSample/PlayerSample.xcodeproj'
    link_with ['PlayerSample','PlayerSample Tests','PlayerSampleFlexions']
end
