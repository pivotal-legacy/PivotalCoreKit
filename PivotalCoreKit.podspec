Pod::Spec.new do |s|
  s.name     = 'PivotalCoreKit'
  s.version  = '0.0.2'
  s.license  = { :type => 'MIT', :text => license }
  s.summary  = 'Shared library and test code for iOS projects.'
  s.homepage = 'https://github.com/pivotal/PivotalCoreKit'
  s.author   = { 'Pivotal Labs' => 'http://pivotallabs.com' }
  s.source   = { :git => 'https://github.com/pivotal/PivotalCoreKit.git', :commit => 'fcdd1dde3b7fb3840cc6f59d02257be951346c97' }
  s.platform = :ios

  s.subspec 'Foundation' do |f|
    f.source_files = 'Foundation/Core/**/*.{h,m}'
    f.libraries    = 'xml2'
    f.xcconfig     = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  end

  s.subspec 'UIKit' do |uicore|
    uicore.source_files = 'UIKit/Core/**/*.{h,m}'
    uicore.frameworks   = 'UIKit'
  end

  s.subspec 'UIKitSpecHelper' do |sub|
    sub.source_files = 'UIKit/SpecHelper/**/*.{h,m}'
    sub.frameworks   = 'UIKit'
    sub.dependency 'Cedar'
  end
  
  s.subspec 'SpecHelperLib' do |spec_helper|
    spec_helper.source_files = 'Foundation/SpecHelper/**/*.{h,m}'
    spec_helper.frameworks   = 'UIKit'
    spec_helper.dependency 'Cedar'
  end
end
