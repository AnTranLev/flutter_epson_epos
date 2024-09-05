#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint epson_epos.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'epson_epos'
  s.version          = '0.1.0'
  s.summary          = 'Epson epos printer plugin.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://mthuong.github.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tom' => 'mthuong.github.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  # libepos2.xcframework
  s.preserve_paths = 'libepos2.xcframework/**/*'
  s.vendored_frameworks = 'libepos2.xcframework'
  
  s.libraries = 'xml2'
  s.frameworks = 'CoreBluetooth', 'ExternalAccessory'
  
  # Localization
  s.resource = 'Localizations/ePOS2Localizable.strings'
end
