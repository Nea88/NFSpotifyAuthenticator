#
# Be sure to run `pod lib lint NFSpotifyAuthenticator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NFSpotifyAuthenticator'
  s.version          = '0.1.0'
  s.summary          = 'Spotify authenticator using WebOAuth. Authorization level is 'Authorization Code''

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Spotify Authenticator using WebOAuth that won't require SDK. Authentication conforms to 'Authorization Code' which gives us accesstoken and a refresh token for spotify streaming.
                       DESC

  s.homepage         = 'https://github.com/nferocious76/NFSpotifyAuthenticator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Neil Francis Ramirez Hipona' => 'nferocious76@gmail.com' }
  s.source           = { :git => 'https://github.com/nferocious76/NFSpotifyAuthenticator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/nferocious76'

  s.ios.deployment_target = '9.3'

  s.source_files = 'NFSpotifyAuthenticator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NFSpotifyAuthenticator' => ['NFSpotifyAuthenticator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

s.dependency 'Alamofire', '~> 4.0.1'

end
