extend Opscode::OpenSSL::Password

node.set_unless['load-generator']['db']['password'] = secure_password
node.set_unless['load-generator']['env']['SECRET_KEY_BASE'] = secure_password
node.set['apt']['compile_time_update'] = true
node.set['build-essential']['compile_time'] = true
node.save
