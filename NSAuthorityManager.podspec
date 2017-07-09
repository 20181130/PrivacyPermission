Pod::Spec.new do |s|
  s.name         = "NSAuthorityManager"
  s.version      = "1.0.0"
  s.summary      = "iOS Equipment Authorization Management."
  s.description  = <<-DESC
  You Can Use 'NSAuthorityManager' to manager your equipment authorization.
                   DESC
  s.homepage     = "https://github.com/GREENBANYAN/NSAuthorityManager"
  s.license      = "MIT"
  s.author             = { "GREENBANYAN" => "@greenbanyan@163.com" }
  s.platform     = :ios,'8.0'
  s.source       = { :git => "https://github.com/GREENBANYAN/NSAuthorityManager", :tag => "#{s.version}" }
  s.source_files  = "NSAuthorityManager/*.{h,m}"
  s.requires_arc = true
end
