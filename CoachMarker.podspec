Pod::Spec.new do |s|
  s.name          = "CoachMarker"
  s.version       = "2.0.0"
  s.summary       = "A simple onboard tutorial helper."
  s.description   = "You can mark components with circles or rectangles via coordinates"
  s.homepage      = "https://github.com/vicaren/CoachMarker"
  s.screenshots   = "https://github.com/vicaren/CoachMarker/blob/master/images/coachMarker-tutorial.gif"
  s.license       = "MIT"
  s.author        = { "thevicaren@gmail.com" => "thevicaren@gmail.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/vicaren/CoachMarker.git", :tag => "#{s.version}" }
  s.source_files  = "CoachMarker/**/*"
  s.exclude_files = "CoachMarker/**/*.plist"
end
