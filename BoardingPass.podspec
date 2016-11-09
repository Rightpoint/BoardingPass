Pod::Spec.new do |s|
  s.name             = 'BoardingPass'
  s.version          = '0.2.0'
  s.summary          = 'A navigation controller interactive pan to push and pop.'

  s.description      = <<-DESC
BoardingPass is a subclass of `UINavigationController` with interactive push
and pop gestures. It's offers behaviors similar to `UIPageViewController`,
but with all of the familiar behaviors of navigation controller, and the
ability to add fancy effects by animating alongside transitions.
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
