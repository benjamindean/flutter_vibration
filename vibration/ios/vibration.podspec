#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint vibration.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'vibration'
  s.version          = '3.0.0'
  s.summary          = 'A plugin for handling Vibration API on iOS, Android, web and OpenHarmony.'
  s.description      = <<-DESC
A plugin for handling Vibration API on iOS, Android, web and OpenHarmony.
                       DESC
  s.homepage         = 'https://github.com/benjamindean/flutter_vibration'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Benjamin Dean' => 'benjaminabel.cellardoor@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'vibration/Sources/vibration/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.resource_bundles = {'vibration_privacy' => ['vibration/Sources/vibration/Resources/PrivacyInfo.xcprivacy']}
end
