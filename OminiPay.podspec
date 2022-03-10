Pod::Spec.new do |s|
  s.name         =  'OminiPay'
  s.version      =  '1.1'
  s.license      =  { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     =  'https://github.com/rahulwdp/Omini_Pay_iOS'
  s.authors      =  { 'PSP' => 'info@digitalworld.com.sa'}
  s.source       =  { :git => 'https://github.com/rahulwdp/Omini_Pay_iOS.git', :tag => s.version.to_s }

  s.summary      =  'Safe and Secure payment class'
  s.description  =  'Safe and Secure payment class'
  s.platforms = { :ios => '12.1' }
  s.vendored_frameworks = "Framework/OminiPay.framework"
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end