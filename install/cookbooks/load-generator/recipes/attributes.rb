extend Opscode::OpenSSL::Password

# node.set_unless['load-generator']['db']['password'] = secure_password
# node.set_unless['load-generator']['env']['SECRET_KEY_BASE'] = secure_password
node.default['apt']['compile_time_update'] = true
node.default['build-essential']['compile_time'] = true
# node.save
