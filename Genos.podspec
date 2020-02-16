Pod::Spec.new do |s|
  s.name             = 'Genos'
  s.version          = '0.2.2'
  s.license          = 'MIT'
  s.homepage         = 'https://github.com/nyssance/GenosSwift'
  s.author           = { 'NY' => 'nyssance@icloud.com' }
  s.summary          = 'The BEST high-level framework for iOS by NY.'
  s.source           = { :git => 'https://github.com/nyssance/GenosSwift.git', :tag => s.version }
  s.swift_versions   = ['5.0', '5.1']
  s.ios.deployment_target = '11.0'
  s.source_files     = 'Genos/Sources/**/*.swift'
  s.resource_bundles = { 'Genos' => ['Genos/Resources/**/*'] }

  s.dependency 'HMSegmentedControl'

  s.dependency 'Alamofire', '5.0.0'
  s.dependency 'DeviceKit', '3.0.0'
  s.dependency 'Kingfisher', '5.13.0'
  s.dependency 'SwiftyBeaver', '1.8.4'
  s.dependency 'SwiftDate', '6.1.0'
  s.dependency 'SwiftEventBus'
  s.dependency 'SwiftyUserDefaults', '5.0.0'

  s.dependency 'GrowingTextView', '0.7.2'
  s.dependency 'IQKeyboardManagerSwift', '6.5.5'
  s.dependency 'JSSAlertView'
  s.dependency 'SwiftIcons'
end
