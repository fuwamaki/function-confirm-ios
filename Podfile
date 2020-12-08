platform :ios, '14.0'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_unused_master_specs_repo => false

target 'FunctionConfirm' do
  use_frameworks!
  inhibit_all_warnings!
  pod 'APIKit', '~> 5.1.0'
  pod 'Cartography', '~> 4.0.0'
  pod 'KRProgressHUD', '~> 3.4.4'
  pod 'AWSRekognition', '~> 2.19.1'
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
  pod 'SwiftLint', '~> 0.41.0'
  pod 'ReSwift', '~> 6.0.0'
  pod 'PanModal'

  target 'FunctionConfirmTests' do
    inherit! :search_paths
    pod 'RxTest', '~> 5.1.1'
    pod 'RxBlocking', '~> 5.1.1'
  end
end

