Pod::Spec.new do |s|
  s.name             = 'flutter_izipay'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/briansalvattore/flutter_izipay'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Brian Salvattore' => 'briansalvattore@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '17.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.vendored_frameworks = 'Frameworks/IzipayPayButtonSDK.framework' ,'Frameworks/MastercardSonic.xcframework' ,'Frameworks/VisaSensoryBranding.xcframework'
end
