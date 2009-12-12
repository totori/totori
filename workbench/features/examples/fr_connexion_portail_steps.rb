
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

Alors /je devrais voir le message d'erreur "(.+)"/ do |text|
  @portal.reports_error?(text)
end

Alors /je devrais voir le message d'avertissement "(.+)"/ do |text|
  @portal.reports_warning?(text)
end

Alors /je devrais voir le message de succès "(.+)"/ do |text|
  @portal.reports_success?(text)
end

Alors /je devrais être déconnecté/ do
  !@portal.logged_in?
end
