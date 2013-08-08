workspace 'Watt'
xcodeproj 'PlayerSample/PlayerSample.xcodeproj'
xcodeproj 'WattAuthor/WattAuthor.xcodeproj'

target :PlayerSample do
    platform :ios, '6.0'
	pod 'AFNetworking','~>1.3.1'
	pod 'SVProgressHUD'
	pod 'SSZipArchive','~> 0.2.2'
    xcodeproj 'PlayerSample/PlayerSample.xcodeproj'
end

target :PlayerSampleFlexions do
    platform :ios, '6.0'
    pod 'AFNetworking','~>1.3.1'
	pod 'SVProgressHUD'
	pod 'SSZipArchive','~> 0.2.2'
    xcodeproj 'PlayerSample/PlayerSample.xcodeproj'
end

target :WattAuthor do
    platform :osx , '10.8'
	pod 'AFNetworking','~>1.3.1'
	pod 'SSZipArchive','~> 0.2.2'
    xcodeproj 'WattAuthor/WattAuthor.xcodeproj'
end


#######
# note 

# For development purpose i link directly a shared watt folder
#pod 'Watt', {:git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}

#those dependencies are directly "linked in Watt" when using watt podspec
#pod 'AFNetworking','~>1.3.1'
#pod 'SVProgressHUD'
#pod 'SSZipArchive','~> 0.2.2'
