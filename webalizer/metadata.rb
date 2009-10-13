maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures webalizer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"
recipe            "webalizer", "Main Webalizer configuration"

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end
