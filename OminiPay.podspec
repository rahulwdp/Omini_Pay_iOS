Pod::Spec.new do |s|
  s.name         =  'OminiPay'
  s.version      =  '1.0.0'
  s.license      =  { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     =  'https://github.com/rahulwdp/Omini_Pay_iOS'
  s.authors      =  { 'PSP' => 'info@digitalworld.com.sa'}
  s.source       =  { :git => 'hhttps://github.com/rahulwdp/Omini_Pay_iOS.git', :tag => s.version.to_s }

  s.summary      =  'Safe and Secure payment class'
  s.description  =  'Safe and Secure payment class'

  s.source_files = "Framework/OminiPay.framework/Headers/OminiPay.{h}"
end