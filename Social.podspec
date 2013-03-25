Pod::Spec.new do |s|
  s.name         = "Social"
  s.version      = "1.8.1"
  s.summary      = "umeng social sdk."
  s.homepage     = "http://dev.umeng.com/doc/document_social_ios.html"
  s.license           = {
    :type => "Copyright",
    :text => <<-LICENSE 
    Copyright 2011 - 2013 Umeng.com. All rights reserved. 
    LICENSE
  }
  s.author            = { "umeng" => "support@umeng.com" }
  s.source            = { :http => "http://dev.umeng.com/files/download/UMSocial_Sdk_All_1.8.zip"}
  s.source_files      = 'Classes', 'UMSocial_Sdk_1.8.1/SocialPlugin/*.{h,m}',
  'Classes','UMSocial_Sdk_1.8.1/Headers/*/*.h','Classes','UMSocial_Sdk_1.8.1/frameworks/Wechat/*.h'
  s.resources         = "UMSocial_Sdk_1.8.1/UMSocialSDKResources.bundle"
  s.library 	      = "UMSocial_Sdk_1.8.1/UMSocial_Sdk_1.8.1.a"
  s.platform           = :ios,'4.3'
end
