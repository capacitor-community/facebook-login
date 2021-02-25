  Pod::Spec.new do |s|
    s.name = 'CapacitorCommunityFacebookLogin'
    s.version = '1.1.0'
    s.summary = 'Facebook Login plugin for Capacitor'
    s.license = 'MIT'
    s.homepage = 'https://github.com/capacitor-community/facebook-login'
    s.author = 'Masahiko Sakakibara'
    s.source = { :git => 'https://github.com/capacitor-community/facebook-login', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'FBSDKCoreKit', '9.0.1'
    s.dependency 'FBSDKLoginKit', '9.0.1'
  end
