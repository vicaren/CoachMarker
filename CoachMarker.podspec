Pod::Spec.new do |s|
  s.name          = "CoachMarker"
  s.version       = "1.0.0"
  s.summary       = "A simple onboard tutorial helper."
  s.description   = "You can mark components with circles or rectangles via coordinates"
  s.homepage      = "https://github.com/vicaren/CoachMarker"
  s.screenshots   = "https://media.giphy.com/media/1QkVscQMop9JU1b0Wk/giphy.gif"
  s.license       = "MIT"
  #s.license       = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author        = { "thevicaren@gmail.com" => "thevicaren@gmail.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/vicaren/CoachMarker.git", :tag => "#{s.version}" }
  s.source_files  = "CoachMarker/**/*"
  s.exclude_files = "CoachMarker/**/*.plist"
end
