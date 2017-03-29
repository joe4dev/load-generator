name             'jmeter'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'MIT'
description      'Installs/Configures Apache JMeter'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends 'apt', '~> 5.0.1'
depends 'ark', '~> 2.2.1'
depends 'poise-service', '~> 1.4.2'

# Only for 'java_custom' recipe
# depends 'java', '~> 1.31.0'
