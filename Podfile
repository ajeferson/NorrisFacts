plugin 'cocoapods-binary'

platform :ios, '13.5'

target 'NorrisFacts' do
  use_frameworks!
  all_binary!
  enable_bitcode_for_prebuilt_frameworks!
  keep_source_code_for_prebuilt_frameworks!

  pod 'Moya/RxSwift', '~> 14.0'
  pod 'RealmSwift', '~> 5.0'

  target 'NorrisFactsTests' do
    inherit! :search_paths
  end
end
