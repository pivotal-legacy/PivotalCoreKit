Pod::Spec.new do |s|
  s.name     = 'PivotalCoreKit'
  s.version  = '0.3.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE.markdown' }
  s.summary  = 'Shared library and test code for iOS projects.'
  s.homepage = 'https://github.com/pivotal/PivotalCoreKit'
  s.author   = { 'Pivotal Labs' => 'http://pivotallabs.com' }
  s.source   = { :git => 'https://github.com/pivotal/PivotalCoreKit.git', :tag => 'v0.3.0' }
  s.ios.platform = :ios, '6.0'
  s.tvos.platform = :tvos, '9.0'
  s.requires_arc = false

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.dependency 'PivotalCoreKit/UIKit/Core'
    core.dependency 'PivotalCoreKit/Foundation/Core'
  end

  s.subspec 'Development' do |dev|
    dev.dependency 'PivotalCoreKit/Core'
    dev.dependency 'PivotalCoreKit/Foundation/SpecHelper'
    dev.dependency 'PivotalCoreKit/UIKit/SpecHelper'
    dev.dependency 'PivotalCoreKit/CoreLocation/SpecHelper'
  end

  s.subspec 'UIKit' do |ui|
    ui.subspec 'Core' do |uicore|
      uicore.source_files = 'UIKit/Core/**/*.{h,m}'
      arc_files = 'UIKit/Core/Extensions/UIView+PCKNibHelpers.{h,m}'
      uicore.exclude_files = arc_files
      uicore.subspec 'Core-arc' do |core_arc|
        core_arc.requires_arc = true
        core_arc.source_files = arc_files
      end
    end

    ui.subspec 'SpecHelper' do |spec|
      spec.subspec 'Extensions' do |ext|
        ext.source_files = ['UIKit/SpecHelper/Extensions/**/*.{h,m}', 'UIKit/SpecHelper/UIKit+PivotalSpecHelper.h']
        ext.tvos.exclude_files = '**/iOS/**'

        ext.dependency 'PivotalCoreKit/UIKit/SpecHelper/Support'
      end

      spec.subspec 'Matchers' do |match|
        match.source_files = 'UIKit/SpecHelper/Matchers/*.{h,m}'
      end

      spec.subspec 'Stubs' do |stub|
        stub.requires_arc = true
        stub.source_files = ['UIKit/SpecHelper/Stubs/**/*.{h,m}', 'UIKit/SpecHelper/UIKit+PivotalSpecHelperStubs.h']
        stub.dependency 'PivotalCoreKit/UIKit/SpecHelper/Support'
        narc_files = ['UIKit/SpecHelper/Stubs/UIGestureRecognizer+Spec.*']
        stub.exclude_files = narc_files
        stub.tvos.exclude_files = '**/iOS/**'

        stub.subspec 'Stubs-noarc' do |narc|
          narc.requires_arc = false
          narc.source_files = narc_files
        end
      end

      spec.subspec 'Support' do |helper|
        helper.source_files = ['UIKit/SpecHelper/Support/*.{h,m}']
      end
    end
  end

  s.subspec 'Foundation' do |f|
    f.ios.deployment_target = '6.0'
    f.osx.deployment_target = '10.6'
    f.watchos.deployment_target = '2.0'
    f.tvos.deployment_target = '9.0'

    f.subspec 'Core' do |c|
      c.source_files = 'Foundation/Core/**/*.{h,m}'
      c.libraries    = 'xml2'
      c.xcconfig     = {'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
    end

    f.subspec 'SpecHelper' do |spec_helper|
      spec_helper.source_files = [ 'Foundation/SpecHelper/Foundation+PivotalSpecHelper.h' ]

      spec_helper.subspec 'Extensions' do |ext|
        ext.source_files = ['Foundation/SpecHelper/Extensions/*.{h,m}', 'Foundation/Core/Extensions/NSObject+MethodRedirection.{h,m}']
        ext.dependency 'PivotalCoreKit/Foundation/SpecHelper/Helpers'
        ext.dependency 'PivotalCoreKit/Foundation/SpecHelper/Fakes'
      end

      spec_helper.subspec 'Fixtures' do |fix|
        fix.source_files = 'Foundation/SpecHelper/Fixtures/*.{h,m}'
      end

      spec_helper.subspec 'Helpers' do |help|
        help.source_files = ['Foundation/SpecHelper/Helpers/*.{h,m}', 'Foundation/SpecHelper/Extensions/NSURLConnection+Spec.h']
      end

      spec_helper.subspec 'Fakes' do |fake|
        fake.source_files = 'Foundation/SpecHelper/Fakes/*.{h,m}'
        fake.dependency 'PivotalCoreKit/Foundation/SpecHelper/Fixtures'
      end
    end
  end

  s.subspec 'CoreLocation' do |location|
    location.ios.deployment_target = '6.0'
    location.osx.deployment_target = '10.6'
    location.watchos.deployment_target = '2.0'
    location.tvos.deployment_target = '9.0'

    location.subspec 'SpecHelper' do |h|
      h.subspec 'Base' do |base|
        base.source_files = 'CoreLocation/SpecHelper/*.{h,m}'
      end

      h.subspec 'Extensions' do |ext|
        ext.source_files = 'CoreLocation/SpecHelper/Extensions/*.{h,m}'
      end
    end
  end

  s.subspec 'WatchKit' do |watchkit|
    watchkit.requires_arc = true
    watchkit.subspec 'WatchKit' do |child_watchkit|
      child_watchkit.source_files = 'WatchKit/WatchKit/*.{h,m}'
    end
  end
end
