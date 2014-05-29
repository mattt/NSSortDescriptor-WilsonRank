Pod::Spec.new do |s|
  s.name     = 'NSSortDescriptor+WilsonRank'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'The Correct Way To Rank Up/Down Voted Items.'
  s.homepage = 'https://github.com/mattt/NSSortDescriptor-WilsonRank'
  s.social_media_url = 'https://twitter.com/mattt'
  s.authors  = { 'Mattt Thompson' => 'm@mattt.me' }
  s.source   = { :git => 'https://github.com/mattt/NSSortDescriptor-WilsonRank.git', :tag => '0.0.1' }
  s.source_files = 'NSSortDescriptor+WilsonRank'
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
end
