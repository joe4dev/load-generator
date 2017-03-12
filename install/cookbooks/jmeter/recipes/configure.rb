jmeter_script = "/usr/local/bin/jmeter"

heap_regex = %r{HEAP="-Xms\d+m -Xmx\d+m"}
new_heap = "HEAP=\"#{node['jmeter']['heap']}\""

# NOTICE: `PERM` is deprecated since Java 8. Only used to support Java < 8 here.
perm_regex = %r{PERM="-XX:PermSize=\d+m -XX:MaxPermSize=\d+m"}
new_perm = "PERM=\"#{node['jmeter']['perm']}\""

ruby_block "increase memory for JMeter" do
  block do
    sed = Chef::Util::FileEdit.new(jmeter_script)
    sed.search_file_replace(heap_regex, new_heap)
    sed.search_file_replace(perm_regex, new_perm)
    sed.write_file
  end
end
