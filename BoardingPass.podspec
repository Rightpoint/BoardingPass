Pod::Spec.new do |s|
  s.name             = 'BoardingPass'
  s.version          = '0.1.0'
  s.summary          = 'A Springboard-like navigation stack.'

  s.description      = <<-DESC
A springboard like view controller that allows for arbitrary
                       DESC

  s.homepage         = 'https://github.com/Raizlabs/BoardingPass'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Michael Skiba' => 'mike.skiba@raizlabs.com' }
  s.source           = { :git => 'https://github.com/Raizlabs/BoardingPass.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ateliercw'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BoardingPass/**/*'

  s.frameworks   = 'Foundation', 'UIKit'

end
