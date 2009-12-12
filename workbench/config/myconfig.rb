# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Configuration of the portal
#
class MyConfig
  # Root URL
  def root_url
    _root + 'irj/portal'
  end
  
  # Valid credential
  def valid_credential
    {:name => 'user_01', :password => 'abcd1234'}
  end
  
private
  # Root part (http://<host>:<port>/)
  def _root
    #'http://192.168.0.13:50000/'
    'http://srm.tatamotors.com/'
  end
end
