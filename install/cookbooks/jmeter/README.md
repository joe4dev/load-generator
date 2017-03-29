# jmeter

Installs and deploys Apache JMeter: http://jmeter.apache.org/

## Platforms

* Ubuntu 14.04 LTS

## Usage

Add the default recipe to your run list: `recipe[jmeter::default]`

Additionally add the `jmeter::service` recipe if you want to start a JMeter server as a slave node.

## Administration

* Installation directory: `/usr/local/jmeter/bin/jmeter`

* JMeter server Upstart config: `/etc/init/jmeter-server.conf`

* Start service:

    ```shell
    sudo service jmeter-server start
    ```

* Stop service:

    ```shell
    sudo service jmeter-server stop
    ```

* Check logs:

    ```shell
    tail -f /var/log/upstart/jmeter-server.log
    ```

