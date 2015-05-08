json.array!(@jmeter_tasks) do |jmeter_task|
  json.extract! jmeter_task, :id, :test_plan, :benchmark, :node, :status
  json.url jmeter_task_url(jmeter_task, format: :json)
end
