platform :ios, '7.0'

pod 'AFNetworking', '~> 2.0.3'
pod 'ASIHTTPRequest', '~> 1.8.1'
pod 'MBProgressHUD', '~> 0.8'
pod 'Cordova', '~> 3.2.0'
pod 'JSMessagesViewController', '~> 4.0.2'
#pod 'UIBubbleTableView', '~> 0.2'
pod 'SWTableViewCell', '~> 0.2.2'
#pod 'XMPPFramework', '~> 3.6.3'
# Remove 64-bit build architecture from Pods targets
post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |configuration|
      target.build_settings(configuration.name)['ARCHS'] = '$(ARCHS_STANDARD_32_BIT)'
    end
  end
end
