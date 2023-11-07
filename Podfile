platform :ios, '13.0'

target 'CourseGrab' do
  use_frameworks!

  # Pods for CourseGrab
  pod 'AppDevAnnouncements', :git => 'https://github.com/cuappdev/appdev-announcements.git'
  pod 'DZNEmptyDataSet'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
  pod 'FutureNova', :git => 'https://github.com/cuappdev/ios-networking.git'
  pod 'GoogleSignIn'
  pod 'NotificationBannerSwift'
  pod 'ReachabilitySwift'
  pod 'Siren'
  pod 'SnapKit'
  pod 'SPPermissions/Notification'
  pod 'Tactile'
  pod 'Wormholy', :configurations => ['Debug']

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings[‘IPHONEOS_DEPLOYMENT_TARGET’] = ‘13’
      config.build_settings[‘ARCHS[sdk=iphonesimulator*]’] = ‘x86_64’
    end
      if target.respond_to?(:product_type) and target.product_type == “com.apple.product-type.bundle”
        target.build_configurations.each do |config|
            config.build_settings[‘CODE_SIGNING_ALLOWED’] = ‘NO’
        end
      end
      # Make it work with GoogleDataTransport
      if target.name.start_with? “GoogleDataTransport”
        target.build_configurations.each do |config|
          config.build_settings[‘CLANG_WARN_STRICT_PROTOTYPES’] = ‘NO’
        end
      end
  end
end
end
