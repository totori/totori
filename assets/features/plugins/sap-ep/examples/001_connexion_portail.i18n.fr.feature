# language: fr

# Totori - User Acceptance Testing Workbench
# http://github.com/totori/totori - MIT License

@example @fr
Fonctionnalité: Connexion et déconnexion du portail
  Afin de vérifier l'accès au portail
  En tant qu'utilisateur
  Je souhaite me connecter au portail, l'utiliser, puis me déconnecter
  
  @example
  Plan du Scénario: Connexions non autorisées
    Soit je suis sur la page d'accueil
    Et je ne suis pas identifié
    Lorsque je m'enregistre avec les identifiants <utilisateur> et <mot de passe>
    Alors je devrais voir le message d'erreur "Echec de l'authentification de l'utilisateur"
    
    Exemples:
      | utilisateur    | mot de passe |
      | unknown_user_1 | toto         |
      | unknown_user_2 | toto         |
      | unknown_user_3 | toto         |
  
  @example
  Plan du Scénario: Connexions autorisées
    Soit je suis sur la page d'accueil
    Et je ne suis pas identifié
    Lorsque je m'enregistre avec les identifiants <utilisateur> et <mot de passe>
    Alors je devrais être connecté
    
    Exemples:
      | utilisateur    | mot de passe |
	    | user_01        | abcd1234     |
  
  @example
  Scénario: Déconnexion
    Soit je suis identifié
    Lorsque je me déconnecte
    Alors je devrais être déconnecté
