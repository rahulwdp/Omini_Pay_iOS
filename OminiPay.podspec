Pod::Spec.new do |s|
  s.name         =  'OminiPay'
  s.version      =  '1.0'
  s.license      =  { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     =  'https://github.com/rahulwdp/Omini_Pay_iOS'
  s.authors      =  { 'PSP' => 'info@digitalworld.com.sa'}
  s.source       =  { :git => 'https://github.com/rahulwdp/Omini_Pay_iOS.git', :tag => s.version.to_s }

  s.summary      =  'Safe and Secure payment class'
  s.description  =  'Safe and Secure payment class'
  s.iios.deployment_target = '12.0'
  s.vendored_frameworks = "Framework/OminiPay.framework"
end