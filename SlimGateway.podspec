Pod::Spec.new do |spec|
  spec.name                = "SlimGateway"
  spec.version             = "1.0.1"
  spec.summary             = "Extremely simple Restful Network Layer."
  spec.homepage            = "https://github.com/juanjo72/SlimGateway"
  spec.license             = { :type => 'MIT' }
  spec.author              = { "Juanjo Villaescusa" => "https://github.com/juanjo72/SlimGateway" }
  spec.source              = { :git => "https://github.com/juanjo72/SlimGateway.git", :tag => "#{spec.version}" }
  spec.source_files        = "SlimGateway/*.{swift,m,h}"

  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.13"
  spec.watchos.deployment_target = "4.0"
  spec.tvos.deployment_target = "11.0"
  spec.swift_version = "5.0"
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
end
