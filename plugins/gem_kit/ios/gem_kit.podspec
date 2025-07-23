#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gem_kit.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gem_kit'
  s.version          = '2.23.0'
  s.summary          = 'GEMKit Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://www.magiclane.com'
  s.license          = { :file => '../LICENSES/LicenseRef-MagicLane-Proprietary.txt' }
  s.author           = { 'Magic Lane' => 'support@magiclane.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  # Simulator framework has been removed - device only
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'SUPPORTED_PLATFORMS' => 'iphoneos', 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) WITH_FLUTTER_FEATURE=1' }
  s.swift_version = '5.0'
  
  # 3rd Party Frameworks.
  s.preserve_paths = 'GEMKit.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework GEMKit' }
  s.vendored_frameworks = 'Frameworks/GEMKit.xcframework'

end
