Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "BasicTableView"
s.summary = "BasicTableView is an alternative way to manage UITableViews."
s.requires_arc = true

# 2
s.version = "0.0.6"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Federico Gentile" => "fgentile95dev@icloud.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/FedeGens/BasicTableView"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/FedeGens/BasicTableView.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"

# 8
s.source_files = "BasicTableView/*.{swift}"

end
