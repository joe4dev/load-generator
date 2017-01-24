# Load Generator

This "hacky" Rails application provides a JSON endpoint to submit JMeter tasks via Cloud WorkBench (https://github.com/sealuzh/cloud-workbench).

## Getting started

### Installation

Docs: https://github.com/joe4dev/load-generator/tree/master/install/cookbooks/load-generator

Initial provisioning currently fails due to non-update PATH as described here: https://github.com/joe4dev/load-generator/issues/1

```shell
cd install/cookbooks/load-generator
vagrant up
vagrant provision
```

### Build

`bundle install`

### Run

```bash
rake db:migrate
foreman start
```

## Usage

Example with Faraday https://github.com/lostisland/faraday from `wordpress-bench` https://github.com/sealuzh/cwb-benchmarks/tree/master/wordpress-bench

```ruby
load_generator = 'localhost:3000'
connection = Faraday.new(:url => "http://#{load_generator}") do |f|
  f.request :multipart
  f.request :json
  f.response :json
  f.adapter Faraday.default_adapter
end
payload = {
  jmeter_task: {
    test_plan_file: Faraday::UploadIO.new('test_plan.jmx', 'application/x-jmeter'),
    benchmark_file: Faraday::UploadIO.new('wordpress_bench_client.rb', 'application/x-ruby'),
    node_file: Faraday::UploadIO.new('node.yml', 'text/x-yaml'),
  }
}
connection.post '/jmeter_tasks', payload
```


## Notes

This app aims to decouple load generation from CWB client nodes.
JMeter provides its own server for remote testing (see http://jmeter.apache.org/usermanual/remote-test.html), however this would require a bi-directional RMI connection between the CWB client node (i.e., system under test) and the load generator which would negatively influence the benchmark.
