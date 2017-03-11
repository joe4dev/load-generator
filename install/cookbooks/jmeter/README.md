# load-generator

Installs and deploys Apache JMeter: http://jmeter.apache.org/

## Platforms

* Ubuntu 14.04 LTS

## Usage

Add the default recipe to your run list: `recipe[jmeter::default]`

Additionally add the `jmeter::jmeter_server` recipe if you want to start JMeter as a slave node.

## Administer

### Installation directory

`/usr/local/jmeter-3.1/bin/jmeter`
