Pod::Spec.new do |s|
  s.name             = 'flutter_izipay'
  s.version          = '1.1.1'
  s.summary          = 'A Flutter wrapper for the official IziPay Android and iOS SDKs.'
  s.description      = <<-DESC
A Flutter wrapper for the official IziPay Android and iOS SDKs, enabling seamless integration of direct payment functionalities into Flutter applications.s.
                       DESC
  s.homepage         = 'https://github.com/briansalvattore/flutter_izipay'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Brian Salvattore' => 'briansalvattore@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.vendored_frameworks = 'Frameworks/IzipayPayButtonSDK.framework' ,'Frameworks/MastercardSonic.xcframework' ,'Frameworks/VisaSensoryBranding.xcframework'
  s.pod_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO'
  }
end
