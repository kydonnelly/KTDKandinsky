
Pod::Spec.new do |s|
  s.name         = "KTDKandinsky"
  s.version      = "0.0.1"
  s.summary      = "An iOS library for playing notes on a grid"
  s.homepage     = "https://github.com/kydonnelly/KTDKandinsky"

  s.license      = {
    :type => 'Mozilla Public License 2.0',
  }

  s.author       = { "Kyle Donnelly" => "kydonnelly@gmail.com" }
  s.source       = { :git => "https://github.com/kydonnelly/KTDKandinsky.git", :branch => "master", :tag => s.version }

  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'

  s.pod_target_xcconfig = {
      'CLANG_CXX_LANGUAGE_STANDARD' => 'compiler-default',
      'CLANG_CXX_LIBRARY' => 'compiler-default',
      
      # Don't ignore compile warnings
      'GCC_WARN_UNUSED_PARAMETER' => 'NO',
      'GCC_TREAT_WARNINGS_AS_ERRORS' => 'YES',
      'SWIFT_TREAT_WARNINGS_AS_ERRORS' => 'YES',

      'DEFINES_MODULE' => 'YES',
      
      'OTHER_CFLAGS' => '-Wall -Wextra',
  }
  
  s.requires_arc = true
  s.module_name = 'KTDKandinsky'
  s.swift_version = '5'

  s.resources = 'KTDKandinsky/Resources/**/*.{mp3}'
  s.source_files = 'KTDKandinsky/Source/**/*.{swift}'

  s.prefix_header_contents = <<-DESC
    #ifdef __OBJC__
      #import <Foundation/Foundation.h>
    #endif
  DESC

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'KTDKandinskyTests/*.{swift}'
  end

end
