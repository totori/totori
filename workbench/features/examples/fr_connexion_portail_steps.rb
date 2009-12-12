# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Example: Portal connection steps (french)
#

Soit /je suis sur la page d'accueil/ do
  @portal.goto(@config.root_url)
end

Soit /je ne suis pas identifié/ do
  if @portal.logged_in?
    @portal.logoff
  end
end

Soit /je suis identifié/ do
  if !@portal.logged_in?
    Soit("je suis sur la page d'accueil")
    user = @config.valid_credential
    Soit("je m'enregistre avec les identifiants #{user[:name]} et #{user[:password]}")
  end
  if !@portal.logged_in?
    raise "Echec d'authentification"
  end
end

Lorsque /je m'enregistre avec les identifiants (.*) et (.*)/ do |user, password|
  @portal.connect(user, password)
end

Lorsque /je me déconnecte/ do
  @portal.logoff
end

Alors /je devrais voir le message (.+) "(.+)"/ do |severity, text|
  case severity
    when "d'erreur" then @portal.reports_error?(text)
    when "d'avertiseement" then @portal.reports_warning?(text)
    when "de succès" then @portal.reports_success?(text)
  end
end

Alors /je devrais être connecté/ do
  @portal.logged_in?
end

Alors /je devrais être déconnecté/ do
  !@portal.logged_in?
end
