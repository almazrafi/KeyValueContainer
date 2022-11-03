Pod::Spec.new do |spec|
  spec.name = "KeyValueContainer"
  spec.version = "1.1.0"
  spec.summary = "Type-safe containers for key-value storage"

  spec.homepage = "https://github.com/almazrafi/KeyValueContainer"
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { "Almaz Ibragimov" => "almazrafi@gmail.com" }
  spec.source = { :git => "https://github.com/almazrafi/KeyValueContainer.git", :tag => "#{spec.version}" }

  spec.swift_version = '5.5'
  spec.requires_arc = true
  spec.source_files = 'Sources/**/*.swift'

  spec.ios.frameworks = 'Foundation'
  spec.ios.deployment_target = "12.0"

  spec.osx.frameworks = 'Foundation'
  spec.osx.deployment_target = "10.14"

  spec.watchos.frameworks = 'Foundation'
  spec.watchos.deployment_target = "5.0"

  spec.tvos.frameworks = 'Foundation'
  spec.tvos.deployment_target = "12.0"
end
