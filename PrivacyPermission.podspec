Pod::Spec.new do |s|
  s.name         = "PrivacyPermission"
  s.version      = "2.0.0"
  s.summary      = "PrivacyPermission is a library for accessing various system privacy permissions ."
  s.description  = <<-DESC
PrivacyPermission is a library for accessing various system privacy permissions,you can use it for more friendly access.
                   DESC
  s.homepage     = "https://github.com/GREENBANYAN/PrivacyPermission"
  s.license      = "MIT"
  s.author             = { "GREENBANYAN" => "@greenbanyan@163.com" }
  s.platform     = :ios,'8.0'
  s.source       = { :git => "https://github.com/GREENBANYAN/PrivacyPermission.git", :tag => "#{s.version}" }
  s.source_files  = "PrivacyPermission/*.{h,m}"
  s.requires_arc = true
end
