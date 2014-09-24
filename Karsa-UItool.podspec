Pod::Spec.new do |s|
  s.name         = "HLoggerForIOS"
  s.version      = "1.0"
  s.summary      = "Flexible logging tool."
  s.description  = <<-DESC
                   Flexible logging tool.

                   * The output format of the log , flexible combination
                   * You can set the log level and custom
                   * Policy setting logs
                   DESC
  s.homepage     = "https://github.com/HappyU/HLoggerForIOS"
  s.license      = "MIT"
  s.author             = { "HappyU" => "343686681@qq.com" }
  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.source       = { :git => "https://github.com/HappyU/HLoggerForIOS.git", :tag => "1.0" }
  s.source_files  = "HLoggerForIOS", "HLoggerForIOS/HLoggerForIOS/HLogger/*.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true
end
