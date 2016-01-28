Pod::Spec.new do |spec|
  spec.name = "SSCycleScrollView"
  spec.version = "1.0.3"
  spec.summary = "infinate scroll home page using swift"
  spec.homepage = "https://github.com/dulingkang/SSCycleScrollView"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Shawn Du" => 'dulingkang@163.com' }

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/dulingkang/SSCycleScrollView.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "SSCycleScrollView/**/*.{h,swift}"
  spec.resource	    = "SSCycleScrollView/**/*.{jpg,plist}"
end
