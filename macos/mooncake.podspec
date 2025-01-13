Pod::Spec.new do |s|
    s.name             = 'mooncake'
    s.version          = '0.0.1'
    s.summary          = 'A Dart package for mnemonic sentence generation'
    s.description      = <<-DESC
  A Dart package for mnemonic sentence generation
                         DESC
    s.homepage         = 'http://example.com'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Your Company' => 'email@example.com' }
    s.source           = { :path => '.' }
    s.source_files     = 'Classes/**/*'
    s.platform = :osx, '10.11'
    s.dependency 'FlutterMacOS'
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
    s.swift_version = '5.0'
  end