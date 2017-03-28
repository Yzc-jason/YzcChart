Pod::Spec.new do |s|
  s.name         = "YzcChart"
  s.version      = "0.1.2"
  s.summary      = "Some simple charts"
  s.homepage     = "https://github.com/Yzc-jason/YzcChart"
  s.license      = "MIT"
  s.authors      = { 'jasonye' => 'yzc0253@gmail.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Yzc-jason/YzcChart.git", :tag => s.version }
  s.source_files = 'YzcChart/**/*.{h,m}'
  s.requires_arc = true
end
