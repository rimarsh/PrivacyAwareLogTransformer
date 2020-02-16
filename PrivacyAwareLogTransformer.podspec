Pod::Spec.new do |spec|
  spec.name         = "PrivacyAwareLogTransformer"
  spec.version      = "1.0.0"
  spec.summary      = "A simple logging middleware to help keep user information out of logs."
  spec.homepage     = "http://github.com/rimarsh/PrivacyAwareLogTransformer"
  spec.license      = 'MIT'
  spec.author       = "Riley Marsh"
  spec.source       = { :git => "http://github.com/rimarsh/PrivacyAwareLogTransformer.git", :tag => "1.0.0" }
  
  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.12"
  spec.watchos.deployment_target = "4.0"
  spec.tvos.deployment_target = "11.0"
  
  spec.source_files  = "Sources/**/*.{swift}"
  spec.requires_arc = true
end
