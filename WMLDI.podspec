#
# Be sure to run `pod lib lint WMLDI.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "WMLDI"
  s.version          = "0.1.0"
  s.summary          = "Dependency injection made simple"
  s.description      = <<-DESC
                       Extremly lightweight dependency injection
                       DESC
  s.homepage         = "https://github.com/Wondermall/WMLDI"
  s.license          = 'MIT'
  s.author           = { "Sash Zats" => "sash@zats.io" }
  s.source           = { :git => "https://github.com/Wondermall/WMLDI.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zats'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/*'
end
