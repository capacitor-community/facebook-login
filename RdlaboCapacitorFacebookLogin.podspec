  Pod::Spec.new do |s|
    s.name = 'RdlaboCapacitorFacebookLogin'
    s.version = '1.1.0'
    s.summary = 'Facebook Login plugin for Capacitor'
    s.license = 'MIT'
    s.homepage = 'https://github.com/rdlabo/capacitor-facebook-login'
    s.author = 'Masahiko Sakakibara'
    s.source = { :git => 'https://github.com/rdlabo/capacitor-facebook-login', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'FacebookCore', "0.9.0"
    s.dependency 'FacebookLogin', "0.9.0"
  end
