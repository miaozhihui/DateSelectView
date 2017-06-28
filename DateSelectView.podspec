

Pod::Spec.new do |s|

  s.name         = "DateSelectView"
  s.version      = "0.0.1"
  s.summary      = "A control of date selector"
  s.homepage     = "https://github.com/miaozhihui/DateSelectView"
  s.license      = "MIT"
  s.author             = { "miaozhihui" => "876915224@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/miaozhihui/DateSelectView.git", :tag => "#{s.version}" }
  s.source_files  = "DatePickView/*.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true

end
