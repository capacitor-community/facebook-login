
  Pod::Spec.new do |s|
    s.name = 'RdlaboCapacitorFacebookLogin'
    s.version = '1.0.0-beta.13.0.3'
    s.summary = 'Facebook Login plugin for Capacitor'
    s.license = 'Apache-2.0'
    s.homepage = 'https://github.com/rdlabo/capacitor-facebook-login'
    s.author = 'Sébastian Dejonghe'
    s.source = { :git => 'https://github.com/rdlabo/capacitor-facebook-login', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'FacebookLogin'
  end
