PROJECT_NAME = "PivotalCoreKit"
CONFIGURATION = "Release"
PCK_FRAMEWORK_TARGET_NAME = "PivotalCoreKit"
PSHK_FRAMEWORK_TARGET_NAME = "PivotalSpecHelperKit"
SPECS_TARGET_NAME = "Spec"
PCK_STATIC_LIB_TARGET_NAME = "PivotalCoreKit-StaticLib"
PSHK_STATIC_LIB_TARGET_NAME = "PivotalSpecHelperKit-StaticLib"
UI_SPECS_TARGET_NAME = "UISpec"

SDK_DIR = "/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.3.sdk"
BUILD_DIR = File.join(File.dirname(__FILE__), "build")

def build_dir(effective_platform_name)
  File.join(BUILD_DIR, CONFIGURATION + effective_platform_name)
end

def system_or_exit(cmd, stdout = nil)
  puts "Executing #{cmd}"
  cmd += " >#{stdout}" if stdout
  system(cmd) or raise "******** Build failed ********"
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

task :default => [:trim_whitespace, :build_pck_framework, :build_pshk_framework, :specs, :build_pck_static_lib, :build_pshk_static_lib, :uispecs]
task :cruise do
  Rake::Task[:clean].invoke
  Rake::Task[:build_pck_framework].invoke
  Rake::Task[:build_pshk_framework].invoke
  Rake::Task[:specs].invoke
  Rake::Task[:build_pck_static_lib].invoke
  Rake::Task[:build_pshk_static_lib].invoke
  Rake::Task[:uispecs].invoke
end

task :trim_whitespace do
  system_or_exit(%Q[git status --short | awk '{if ($1 != "D" && $1 != "R") print $2}' | grep -e '.*\.[mh]$' | xargs sed -i '' -e 's/	/    /g;s/ *$//g;'])
end

task :clean do
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -alltargets -configuration #{CONFIGURATION} clean SYMROOT=#{BUILD_DIR}], output_file("clean"))
end

task :build_pck_framework do
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{PCK_FRAMEWORK_TARGET_NAME} -configuration #{CONFIGURATION} build SYMROOT=#{BUILD_DIR}], output_file("specs"))
end

task :build_pshk_framework do
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{PSHK_FRAMEWORK_TARGET_NAME} -configuration #{CONFIGURATION} build SYMROOT=#{BUILD_DIR}], output_file("specs"))
end

task :build_specs do
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{SPECS_TARGET_NAME} -configuration #{CONFIGURATION} build SYMROOT=#{BUILD_DIR}], output_file("specs"))
end

task :build_pck_static_lib do
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{PCK_STATIC_LIB_TARGET_NAME} -configuration #{CONFIGURATION} ARCHS=i386 build SYMROOT=#{BUILD_DIR}], output_file("pck_staticlib"))
end

task :build_pshk_static_lib do
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{PSHK_STATIC_LIB_TARGET_NAME} -configuration #{CONFIGURATION} ARCHS=i386 build SYMROOT=#{BUILD_DIR}], output_file("pshk_staticlib"))
end

task :build_uispecs do
  `osascript -e 'tell application "iPhone Simulator" to quit'`
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{UI_SPECS_TARGET_NAME} -configuration #{CONFIGURATION} ARCHS=i386 build], output_file("uispecs"))
end

task :specs => :build_specs do
  build_dir = build_dir("")
  ENV["DYLD_FRAMEWORK_PATH"] = build_dir
  ENV["CEDAR_REPORTER_CLASS"] = "CDRColorizedReporter"
  system_or_exit("cd #{build_dir}; ./#{SPECS_TARGET_NAME}")
end

require 'tmpdir'
task :uispecs => :build_uispecs do
  ENV["DYLD_ROOT_PATH"] = SDK_DIR
  ENV["IPHONE_SIMULATOR_ROOT"] = SDK_DIR
  ENV["CFFIXED_USER_HOME"] = Dir.tmpdir
  ENV["CEDAR_HEADLESS_SPECS"] = "1"
  ENV["CEDAR_REPORTER_CLASS"] = "CDRColorizedReporter"

  system_or_exit(%Q[#{File.join(build_dir("-iphonesimulator"), "#{UI_SPECS_TARGET_NAME}.app", UI_SPECS_TARGET_NAME)} -RegisterForSystemEvents]);
end
