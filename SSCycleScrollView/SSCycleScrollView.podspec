Pod::Spec.new do |spec|
  spec.name = 'SSCycleScrollView'
  spec.version = '2.1.1'
  spec.summary = 'infinate scroll home page using swift4,无限轮播图'
  spec.homepage = 'https://github.com/dulingkang/SSCycleScrollView'
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { 'Shawn Du' => 'dulingkang@163.com' }

  spec.description      = <<-DESC
    infinate scroll, home page using swift4, 无限轮播图
  DESC

  spec.ios.deployment_target = '8.0'
  spec.source = { :git => 'https://github.com/dulingkang/SSCycleScrollView.git', :tag => spec.version.to_s }
  spec.source_files = 'SSCycleScrollView/**/*.swift'
  spec.dependency 'SDWebImage'
end
