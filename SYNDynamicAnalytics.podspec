Pod::Spec.new do |s|
  s.name             = "SYNDynamicAnalytics"
  s.version          = "0.1.2"
  s.summary          = "Automatically measure screen time on a view controller."
  s.description      = <<-DESC
                       SYNDynamicAnalytics provides a category on UIViewController that automatically handles measuring screen time on any UIViewController subclass. Blocks and delegate support to easily utilize any analytics library.
                       DESC
  s.homepage         = "https://github.com/Syntertainment/SYNDynamicAnalytics"
  s.license          = 'MIT'
  s.author           = { "Sidhant Gandhi" => "sidhantg@syntertainment.com" }
  s.source           = { :git => "https://github.com/Syntertainment/SYNDynamicAnalytics.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'SYNDynamicAnalytics' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
