platform :ios, '14.0'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_unused_master_specs_repo => false

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end

target 'FunctionConfirm' do
  use_frameworks!
  inhibit_all_warnings!
  pod 'APIKit', '~> 5.1.0'
  pod 'Cartography', '~> 4.0.0'
  pod 'KRProgressHUD', '~> 3.4.4'
  pod 'AWSMobileClient'
  pod 'AWSPinpoint'
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
  pod 'SwiftLint', '~> 0.41.0'
  pod 'ReSwift', '~> 6.0.0'
  pod 'PanModal'
  pod 'MessageKit', '~> 3.7.0'
  pod 'PINRemoteImage', '~> 3.0'
  pod 'ImageViewer', '~> 6.0'
  pod 'iosMath'

  target 'FunctionConfirmTests' do
    inherit! :search_paths
    pod 'RxTest', '~> 5.1.1'
    pod 'RxBlocking', '~> 5.1.1'
  end
end
