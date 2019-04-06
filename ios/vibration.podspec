#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'vibration'
  s.version          = '1.0.2'
  s.summary          = 'A plugin for handling Vibration API on iOS and Android devices'
  s.description      = <<-DESC
Handle vibration on iOS and Android
                       DESC
  s.homepage         = 'https://github.com/benjamindean/flutter_vibration'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Benjamin Dean' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.swift_version = '4.0'
  s.ios.deployment_target = '8.0'
end

