name             'load-generator'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'MIT'
description      'Installs/Configures load-generator'
long_description 'Installs/Configures load-generator'
version          '0.1.6'

depends 'apt', '~> 5.0.1'
depends 'git', '~> 5.0.2'
depends 'sudo', '~> 2.7.2'
depends 'rbenv', '~> 1.7.1'
depends 'openssl', '~> 6.1.1'
depends 'database', '~> 6.1.1'
depends 'postgresql', '~> 6.0.1'
depends 'chef_nginx', '~> 5.0.6'
depends 'ark', '~> 2.2.1'

depends 'jmeter', '~> 0.1.0'

# Only for 'java_custom' recipe
# depends 'java', '~> 1.31.0'
