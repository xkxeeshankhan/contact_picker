#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fluttercontactpicker.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fluttercontactpicker'
  s.version          = '3.1.1'
  s.summary          = 'Interact with native OS contact pickers using Flutter'
  s.description      = <<-DESC
Interact with native OS contact pickers using Flutter
                       DESC
  s.homepage         = 'https://github.com/DRSchlaubi/contact_picker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Michael Rittmeister' => 'mik@rittmeister.in' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
