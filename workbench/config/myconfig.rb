# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Configuration of a specific portal
#
class MyConfig
  # Root URL
  def root_url
    _root + 'irj/portal'
  end
  
  # Valid credential
  def valid_credential
    {:name => 'valid_user', :password => 'valid_password'}
  end
  
private
  # Root part (http://<host>:<port>/)
  def _root
    'http://srm.tatamotors.com/'
  end
end
