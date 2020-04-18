Pod::Spec.new do |s|
  s.name             = 'Genos'
  s.version          = '0.2.2'
  s.license          = 'MIT'
  s.homepage         = 'https://github.com/nyssance/GenosSwift'
  s.author           = { 'NY' => 'nyssance@icloud.com' }
  s.summary          = 'The BEST high-level framework for iOS by NY.'
  s.source           = { :git => 'https://github.com/nyssance/GenosSwift.git', :tag => s.version }
  s.swift_versions   = ['5.0', '5.1', '5.2']
  s.ios.deployment_target = '11.0'
  s.source_files     = 'Genos/Sources/**/*.swift'
  s.resource_bundles = { 'Genos' => ['Genos/Resources/**/*'] }

  s.dependency 'Alamofire', '~> 5.0'
  s.dependency 'DeviceKit', '~> 3.0'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'Kingfisher', '~> 5.0'
  s.dependency 'SwiftDate', '~> 6.0'
  s.dependency 'SwiftIcons', '~> 3.0'
  s.dependency 'SwiftyBeaver'
  s.dependency 'SwiftyUserDefaults', '~> 5.0'

  s.dependency 'GrowingTextView', '0.7.2'
  s.dependency 'JSSAlertView'
  s.dependency 'Parchment', '2.3.0'
end
