#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'vibration_web'
  s.version          = '1.6.4'
  s.summary          = 'Web implmentation of Vibration plugin'
  s.description      = <<-DESC
Web implmentation of Vibration plugin
                       DESC
  s.homepage         = 'https://github.com/benjamindean/flutter_vibration'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Benjamin Dean' => 'benjaminabel.cellardoor@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
