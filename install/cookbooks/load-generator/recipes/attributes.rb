extend Opscode::OpenSSL::Password

node.set_unless['load-generator']['db']['password'] = secure_password
node.set_unless['load-generator']['env']['SECRET_KEY_BASE'] = secure_password
node.save
