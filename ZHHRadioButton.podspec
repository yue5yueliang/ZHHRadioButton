Pod::Spec.new do |s|
  s.name             = 'ZHHRadioButton'
  s.version          = '0.0.1'
  s.summary          = '适用于 iOS 的轻量级、可高度自定义的单选按钮组件。'

  s.description      = <<-DESC
ZHHRadioButton 是一个简洁灵活的单选按钮组件，支持自定义样式、动画效果，适用于 iOS 应用中的表单、选项选择等场景。最低支持 iOS 13。
  DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHRadioButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHRadioButton.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'ZHHRadioButton/Classes/**/*'
    # 如果需要，添加依赖项或资源文件
    # core.resources = ['ZHHRadioButton/Assets/*.xcassets']
  end

  # 如果没有额外资源，移除这行更简洁
  # s.source_files = 'ZHHRadioButton/Classes/**/*'

end
