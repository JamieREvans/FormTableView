Pod::Spec.new do |s|
  s.name             = "FormTableView"
  s.version          = "0.1.0"
  s.summary          = "Simple Forms and LinearLayout"
  s.description      = <<-DESC
                       Either create forms in a flash or use it as a linear layout with some great built in functionality.
                       DESC
  s.homepage         = "https://github.com/JamieREvans/FormTableView"
  s.license          = 'MIT'
  s.author           = { "Jamie Riley Evans" => "jamie.riley.evans@gmail.com" }
  s.source           = { :git => "https://github.com/JamieREvans/FormTableView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
