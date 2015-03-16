CONFIGURATION = "Release"
BUILD_SDK_VERSION = ENV['BUILD_SDK_VERSION'] || "8.2"
SIMULATOR_VERSIONS = ENV['SIMULATOR_VERSIONS'] || "8.2"
SIMULATOR_DEVICES = ENV['SIMULATOR_DEVICES'] || "iPhone 5s"
BUILD_DIR = File.join(File.dirname(__FILE__), "build")

require 'tmpdir'

def build_dir(effective_platform_name)
  File.join(BUILD_DIR, CONFIGURATION + effective_platform_name)
end

def system_or_exit(cmd, env_overrides = {}, stdout = nil)
  puts "Executing #{cmd}"
  cmd += " >#{stdout}" if stdout

  old_env = {}
  env_overrides.each do |key, value|
    old_env[key] = ENV[key]
    ENV[key] = value
  end

  system(cmd) or begin
    puts "******** Build failed ********"
    exit(1)
  end

  env_overrides.each do |key, value|
    ENV[key] = old_env[key]
  end
end

def output_file(target)
  output_dir = if ENV['IS_CI_BOX']
    ENV['CC_BUILD_ARTIFACTS']
  else
    build_dir = File.join(File.dirname(__FILE__), "build")
    Dir.mkdir(build_dir) unless File.exists?(build_dir)
    build_dir
  end

  output_file = File.join(output_dir, "#{target}.output")
  puts "Output: #{output_file}"
  output_file
end

def build_and_test_scheme(scheme)
  sdk = 'iphonesimulator' + BUILD_SDK_VERSION
  devices = SIMULATOR_DEVICES.split(",")
  versions = SIMULATOR_VERSIONS.split(",")
  system_or_exit(
    %Q[xcodebuild -workspace PivotalCoreKit.xcworkspace \
      -scheme #{scheme} \
      -sdk #{sdk} \
      build]
  )

  devices.each do |device|
    versions.each do |version|
      `osascript -e 'tell application "iPhone Simulator" to quit'`
      system_or_exit(
        %Q[xcodebuild -workspace PivotalCoreKit.xcworkspace \
          -scheme #{scheme} \
          -sdk #{sdk} \
          -destination platform='iOS Simulator',name='#{device},OS=#{version}' \
          test]
      )
      `osascript -e 'tell application "iPhone Simulator" to quit'`
    end
  end
end

def build_target(target, project: project, output_file: output_file)
  command = %Q[xcodebuild -project #{project}.xcodeproj \
                          -target #{target} \
                          -configuration #{CONFIGURATION} \
                          build \
                          SYMROOT=#{BUILD_DIR}]
  system_or_exit(command, {}, output_file)
end

task :default => [:trim_whitespace, "all:spec"]
task :travis => ["foundation:clean", "uikit:clean", "core_location:clean", "foundation:spec", "uikit:spec", "core_location:spec"]

task :trim_whitespace do
  system_or_exit(%Q[git status --short | awk '{if ($1 != "D" && $1 != "R") print $2}' | grep -e '.*\.[mh]$' | xargs sed -i '' -e 's/	/    /g;s/ *$//g;'])
end

namespace :foundation do
  project = "Foundation/Foundation"

  namespace :build do
    namespace :core do
      task :osx do
        output_file = output_file("foundation:build:core:osx")
        build_target("Foundation+PivotalCore", project: project, output_file: output_file)
      end

      task :ios do
        output_file = output_file("foundation:build:core:ios")
        build_target("Foundation+PivotalCore-StaticLib", project: project, output_file: output_file)
      end
    end

    task :core => ["core:osx", "core:ios"]

    namespace :spec_helper do
      task :osx do
        output_file = output_file("foundation:build:spec_helper:osx")
        build_target("Foundation+PivotalSpecHelper", project: project, output_file: output_file)
      end

      task :ios do
        output_file = output_file("foundation:build:spec_helper:ios")
        build_target("Foundation+PivotalSpecHelper-StaticLib", project: project, output_file: output_file)
      end
    end

    task :spec_helper => ["spec_helper:osx", "spec_helper:ios"]

    namespace :spec_helper_framework do
      task :ios do
        output_file = output_file("foundation:build:spec_helper_framework:ios")
        build_target("Foundation+PivotalSpecHelper-iOS", project: project, output_file: output_file)
      end
    end

    task :spec_helper_framework => ["spec_helper_framework:ios"]
  end

  namespace :spec do
    task :osx => ["build:core:osx", "build:spec_helper:osx"] do
      output_file = output_file("foundation:spec:osx")
      build_target("FoundationSpec", project: project, output_file: output_file)

      build_dir = build_dir("")
      env_vars = {
        "CEDAR_REPORTER_CLASS" => "CDRColorizedReporter",
        "CFFIXED_USER_HOME" => Dir.tmpdir,
        "DYLD_FRAMEWORK_PATH" => build_dir
      }
      system_or_exit("cd #{build_dir}; ./FoundationSpec", env_vars)
    end

    task :ios do
      build_and_test_scheme("Foundation-StaticLibSpec")
    end
  end

  task :build => ["foundation:build:core", "foundation:build:spec_helper"]
  task :spec => ["foundation:spec:osx", "foundation:spec:ios"]
  task :clean do
    system_or_exit(%Q[xcodebuild -project #{project}.xcodeproj -alltargets -configuration #{CONFIGURATION} clean SYMROOT=#{BUILD_DIR}], {}, output_file("foundation:clean"))
  end
end

task :foundation => ["foundation:build", "foundation:spec"]

namespace :uikit do
  project = "UIKit/UIKit"

  namespace :build do
    namespace :core do
      task :ios do
        output_file = output_file("uikit:build:core:ios")
        build_target("UIKit+PivotalCore-StaticLib", project: project, output_file: output_file)
      end
    end

    task :core => ["core:ios"]

    namespace :spec_helper do
      task :ios do
        output_file = output_file("uikit:build:spec_helper:ios")
        build_target("UIKit+PivotalSpecHelper-StaticLib", project: project, output_file: output_file)
      end

      task :ios_stubs do
        output_file = output_file("uikit:build:spec_helper:ios_stubs")
        build_target("UIKit+PivotalSpecHelperStubs-StaticLib", project: project, output_file: output_file)
      end
    end

    task :spec_helper => ["spec_helper:ios", "spec_helper:ios_stubs"]

    namespace :spec_helper_framework do
      task :ios do
        output_file = output_file("uikit:build:spec_helper_framework:ios")
        build_target("UIKit+PivotalSpecHelper-iOS", project: project, output_file: output_file)
      end

      task :ios_stubs do
        output_file = output_file("uikit:build:spec_helper_framework:ios_stubs")
        build_project("UIKit+PivotalSpecHelperStubs-iOS", project: project, output_file: output_file)
      end
    end

    task :spec_helper_framework => ["spec_helper_framework:ios", "spec_helper_framework:ios_stubs"]
  end

  namespace :spec do
    task :ios do
      build_and_test_scheme("UIKit-StaticLibSpec")
    end
  end

  task :build => ["build:core"]
  task :spec => ["spec:ios"]
  task :clean do
    system_or_exit(%Q[xcodebuild -project #{project}.xcodeproj -alltargets -configuration #{CONFIGURATION} clean SYMROOT=#{BUILD_DIR}], {}, output_file("uikit:clean"))
  end
end

task :uikit => ["uikit:build", "uikit:spec"]

namespace :core_location do
  project = "CoreLocation/CoreLocation"

  namespace :build do
    namespace :spec_helper do
      task :osx do
        output_file = output_file("core_location:build:spec_helper:osx")
        build_target("CoreLocation+PivotalSpecHelper", project: project, output_file: output_file)
      end

      task :ios do
        output_file = output_file("core_location:build:spec_helper:ios")
        build_target("CoreLocation+PivotalSpecHelper-StaticLib", project: project, output_file: output_file)
      end
    end

    task :spec_helper => ["spec_helper:osx", "spec_helper:ios"]
  end

  namespace :spec do
    task :osx => ["build:spec_helper:osx"] do
      output_file = output_file("core_location:spec:osx")
      build_target("CoreLocationSpec", project: project, output_file: output_file)

      build_dir = build_dir("")
      env_vars = {
        "DYLD_FRAMEWORK_PATH" => build_dir,
        "CEDAR_REPORTER_CLASS" => "CDRColorizedReporter"
      }
      system_or_exit("cd #{build_dir}; ./CoreLocationSpec", env_vars)
    end

    task :ios do
      build_and_test_scheme("CoreLocation-StaticLibSpec")
    end
  end

  task :build => ["build:spec_helper"]
  task :spec => ["spec:osx", "spec:ios"]
  task :clean do
    system_or_exit(%Q[xcodebuild -project #{project}.xcodeproj -alltargets -configuration #{CONFIGURATION} clean SYMROOT=#{BUILD_DIR}], {}, output_file("core_location:clean"))
  end
end

task :core_location => ["core_location:build", "core_location:spec"]

namespace :watchkit do
  project_name = "WatchKit/WatchKit"

  namespace :build do
    task :ios do
      system_or_exit(%Q[xcodebuild -project #{project_name}.xcodeproj -scheme WatchKit -sdk iphonesimulator8.2 -configuration #{CONFIGURATION} build], {}, output_file("watchkit:build:ios"))
    end
  end

  namespace :spec do
    require 'tmpdir'
    task :ios do
      `osascript -e 'tell application "iPhone Simulator" to quit'`
      system_or_exit(%Q[xcodebuild -project #{project_name}.xcodeproj -scheme WatchKit -sdk iphonesimulator8.2 -destination platform='iOS Simulator',name='iPhone 5s,OS=8.2' build test], {}, output_file("watchkit:spec:ios"))
      `osascript -e 'tell application "iPhone Simulator" to quit'`
    end
  end
  task :spec => ["spec:ios"]
  task :build => ["build:ios"]
  task :clean do
    system_or_exit(%Q[xcodebuild -project #{project_name}.xcodeproj -alltargets -configuration #{CONFIGURATION} -destination platform='iOS Simulator',name='iPhone 5s,OS=8.2' clean SYMROOT=#{BUILD_DIR}], {}, output_file("watchkit:clean"))
  end
end

task :watchkit => ["watchkit:build", "watchkit:spec"]

namespace :all do
  task :build => ["foundation:build", "uikit:build", "core_location:build", "watchkit:build"]
  task :spec => ["foundation:spec", "uikit:spec", "core_location:spec", "watchkit:spec"]
  task :clean => ["foundation:clean", "uikit:clean", "core_location:clean"]
end
