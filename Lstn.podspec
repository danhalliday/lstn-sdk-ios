Pod::Spec.new do |s|
  s.name = "Lstn"
  s.version = "0.1.5"
  s.summary = "Lstn is a podcast player for your app’s text content."
  s.description  = <<-DESC
  Lstn is a SDK and service that turns your app’s text content into playable podcasts. Provide the
  Lstn SDK with an article URL, and it will fetch the article’s text, clean it up, and generate an
  audio version. Lstn provides a customisable player UI, or you can connect your own.
  DESC
  s.homepage = "http://lstn.ltd/"
  s.license = "MIT"
  s.author = "Lstn Ltd"
  s.source = { :git => "https://github.com/lstn-ltd/lstn-sdk-ios.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "10.0"
  s.source_files = "Lstn/Classes/**/*"
end
