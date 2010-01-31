# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Portal basic steps (french)
#

##################################################
# Logging

Soit /je suis sur la page d'accueil/ do
  Given("I am on the main page")
end

Soit /je ne suis pas identifié/ do
  Given("I am not logged in")
end

Soit /je suis identifié/ do
  Given("I am logged in")
end

Lorsque /je m'enregistre avec les identifiants (.*) et (.*)/ do |user, password|
  When("I log in with credentials #{user} and #{password}")
end

Lorsque /je me déconnecte/ do
  When("I log off")
end

Alors /je devrais voir le message (.+) "(.+)"/ do |severity, text|
  Then("I should see the #{severity} message \"#{text}\"")
end

Alors /je devrais être connecté/ do
  Then("I should be logged in")
end

Alors /je devrais être déconnecté/ do
  Then("I should be logged off")
end


##################################################
# Top-level navigation

Lorsque /je clique sur l'onglet "([^\"]*)" du menu de navigation principale/ do |tab|
  When("I click on the \"#{tab}\" main tab in the top-level navigation")
end

Lorsque /je clique sur le sous-onglet "([^\"]*)" du menu de navigation principale'/ do |tab|
  When("I click on the \"#{tab}\" sub-tab in the top-level navigation")
end

Alors /je devrais voir "([^\"]*)" dans la barre de titre de page/ do |title|
  Then("I should see \"#{title}\" in the page title bar")
end

##################################################
# Forms

Lorsque /je saisis le champ "([^\"]*)" avec "([^\"]*)"/ do |field, value|
  When("I fill the field \"#{field}\" with \"#{value}\"")
end

Lorsque /je clique sur le bouton "([^\"]*)"/ do |button|
  When("I click on the button \"#{button}\"")
end

Lorsque /je coche la case à cocher "([^\"]*)"/ do |field|
  When("I check the checkbox \"#{field}\"")
end

Alors /le champ "([^\"]*)" devrait contenir "([^\"]*)"/ do |field, value|
  Then("the field \"#{field}\" should contain \"#{value}\"")
end

Alors /le champ texte "([^\"]*)" devrait contenir "([^\"]*)"/ do |field, value|
  Then("the textview \"#{field}\" should contain \"#{value}\"")
end
