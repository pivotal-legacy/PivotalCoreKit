Pod::Spec.new do |s|
  s.name     = 'PivotalCoreKit'
  s.version  = '0.1.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE.markdown' }
  s.summary  = 'Shared library and test code for iOS projects.'
  s.homepage = 'https://github.com/pivotal/PivotalCoreKit'
  s.author   = { 'Pivotal Labs' => 'http://pivotallabs.com' }
  s.source   = { :git => 'https://github.com/pivotal/PivotalCoreKit.git' }
  s.requires_arc = false

  osx_min_version = '10.8'
  ios_min_version = '6.0'
  s.platform = :ios, ios_min_version

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.dependency 'PivotalCoreKit/UIKit/Core'
    core.dependency 'PivotalCoreKit/Foundation/Core'
  end

  s.subspec 'Development' do |dev|
    dev.dependency 'PivotalCoreKit/Core'
    dev.dependency 'PivotalCoreKit/Foundation/SpecHelper/Extensions'
    dev.dependency 'PivotalCoreKit/Foundation/SpecHelper/Fixtures'
    dev.dependency 'PivotalCoreKit/Foundation/SpecHelper/Helpers'
    dev.dependency 'PivotalCoreKit/Foundation/SpecHelper/Fakes'
    dev.dependency 'PivotalCoreKit/UIKit/SpecHelper/Extensions'
    dev.dependency 'PivotalCoreKit/UIKit/SpecHelper/Matchers'
    dev.dependency 'PivotalCoreKit/UIKit/SpecHelper/Helpers'
    dev.dependency 'PivotalCoreKit/UIKit/SpecHelper/Stubs'
    dev.dependency 'PivotalCoreKit/CoreLocation/SpecHelper/Base'
    dev.dependency 'PivotalCoreKit/CoreLocation/SpecHelper/Extensions'
  end

  s.subspec 'UIKit' do |ui|
    ui.subspec 'Core' do |uicore|
      arc_files = 'UIKit/Core/Extensions/UIView+PCKNibHelpers.m'
      uicore.source_files = 'UIKit/Core/**/*.{h,m}'
      uicore.exclude_files = arc_files
      uicore.subspec 'Core-arc' do |core_arc|
        core_arc.requires_arc = true
        core_arc.source_files = arc_files
      end
    end

    ui.subspec 'SpecHelper' do |spec|
      spec.subspec 'Extensions' do |ext|
        ext.source_files = ['UIKit/SpecHelper/Extensions/*.{h,m}', 'UIKit/SpecHelper/UIKit+PivotalSpecHelper.h']
      end

      spec.subspec 'Matchers' do |match|
        match.source_files = 'UIKit/SpecHelper/Matchers/*.{h,m}'
      end

      spec.subspec 'Stubs' do |stub|
        stub.requires_arc = true
        stub.source_files = ['UIKit/SpecHelper/Stubs/*.{h,m}', 'UIKit/SpecHelper/UIKit+PivotalSpecHelperStubs.h']
      end

      spec.subspec 'Helpers' do |helper|
	helper.source_files = ['UIKit/SpecHelper/Helpers/*.{h,m}']
      end
    end
  end

  s.subspec 'Foundation' do |f|
    f.osx.deployment_target = osx_min_version
    f.ios.deployment_target = ios_min_version

    f.subspec 'Core' do |c|
      c.source_files = 'Foundation/Core/**/*.{h,m}'
      c.libraries    = 'xml2'
      c.xcconfig     = {'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
    end

    f.subspec 'SpecHelper' do |spec_helper|
      spec_helper.subspec 'Extensions' do |ext|
        ext.source_files = ['Foundation/SpecHelper/Foundation+PivotalSpecHelper.h', 'Foundation/Core/Extensions/NSObject+MethodRedirection.h', 'Foundation/SpecHelper/Helpers/PCKConnectionBlockDelegate.h', 'Foundation/SpecHelper/Helpers/PCKConnectionDelegateWrapper.h', 'Foundation/SpecHelper/Fakes/PSHKFakeHTTPURLResponse.h', 'Foundation/SpecHelper/Fakes/FakeOperationQueue.h', 'Foundation/SpecHelper/Extensions/*.{h,m}']
      end

      spec_helper.subspec 'Fixtures' do |fix|
        fix.source_files = 'Foundation/SpecHelper/Fixtures/*.{h,m}'
      end

      spec_helper.subspec 'Helpers' do |help|
        help.source_files = ['Foundation/SpecHelper/Extensions/NSURLConnection+Spec.h', 'Foundation/SpecHelper/Helpers/*.{h,m}']
      end

      spec_helper.subspec 'Fakes' do |fake|
        fake.source_files = 'Foundation/SpecHelper/Fakes/*.{h,m}'
        fake.dependency 'PivotalCoreKit/Foundation/SpecHelper/Fixtures'
      end
    end
  end

  s.subspec 'CoreLocation' do |location|
    location.subspec 'SpecHelper' do |h|
      h.subspec 'Base' do |base|
        base.source_files = 'CoreLocation/SpecHelper/*.{h,m}'
      end

      h.subspec 'Extensions' do |ext|
        ext.source_files = 'CoreLocation/SpecHelper/Extensions/*.{h,m}'
      end
    end
  end
end

