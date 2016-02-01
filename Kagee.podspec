Pod::Spec.new do |s|
  s.name = 'Kagee'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.homepage = 'https://github.com/yukiasai/'
  s.summary = 'HTTP mocking library written in Swift.'
  s.authors = { 'yukiasai' => 'yukiasai@gmail.com' }
  s.source = { :git => 'https://github.com/yukiasai/Kagee.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'Kagee/*.swift'
end

