# Load Generator

This "hacky" Rails application provides a JSON endpoint to submit JMeter tasks via Cloud WorkBench (https://github.com/sealuzh/cloud-workbench).

## Getting started

### Build

`bundle install`

### Run

```bash
rake db:migrate
rails server
rake jobs:work
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
