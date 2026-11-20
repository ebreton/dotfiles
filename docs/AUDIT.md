# Audit de migration macOS

Les propositions ci-dessous reflètent la revue initiale. La gestion manuelle de Poetry a été retenue par la suite. Voir le [journal des décisions](DECISIONS.md).

## État au 20 novembre 2026

- Branche `modernize/chezmoi-starship` au commit `a6cbf6b` du 1er juin 2022, identique à `master` et à la référence locale `origin/master`. L’historique local compte 809 commits et conserve l’héritage mathiasbynens. Le remote utilise SSH. La branche de travail n’a pas de suivi distant configuré. Aucun changement suivi à l’ouverture, et `docs/DECISIONS.md` existait déjà comme fichier non suivi.
- Les derniers changements historiques concernent Poetry et le chargement de `.env`, pyenv, des applications et la veille profonde. L’ancien bootstrap fait un pull explicite de `master` puis utilise rsync vers le dossier personnel. Il n’a pas été exécuté.
- macOS 26.7.3 sur Apple Silicon, Command Line Tools présents, Bash 3.2 et Zsh 5.9 disponibles. Le profil Bash utilisateur initialise uniquement Homebrew. Aucun autre fichier de démarrage Bash/Zsh utilisateur n’a été trouvé aux emplacements standard examinés.
- Git et Python 3 se résolvent vers `/usr/bin`. pyenv, Poetry, Node.js et npm ne sont pas disponibles dans un Bash de connexion nettoyé. Le binaire Node embarqué dans ChatGPT appartient au contexte Codex.
- Les sept inventaires locaux existent. Homebrew contient quatre outils explicitement recensés (`chezmoi`, `gh`, `shellcheck`, `starship`), `gmp` en plus et 22 casks confirmés par le Caskroom. L’interrogation Homebrew des casks a rencontré une restriction sur son cache. Le fichier d’inventaire des taps est vide. `.audit/` est ignoré par `.git/info/exclude` et aucun fichier du dossier n’est suivi. Ajouter `/.audit/` au `.gitignore` partagé pendant la migration.
- `sourceDir` de chezmoi pointe déjà vers le checkout. GitHub CLI a une valeur globale `git_protocol: https`, mais la consultation effective pour `github.com` confirme `ssh`. Le remote du dépôt utilise SSH. Aucun fichier Git global utilisateur standard n’a été trouvé. OpenSSH sélectionne l’agent 1Password via `Host *`. L’authentification GitHub n’a pas été testée en réseau.
- Le `.vimrc` recensé est celui du dépôt. Aucun `~/.vimrc` ni `~/.vim` n’a été trouvé. Vim système et VS Code sont présents. Aucun fichier utilisateur VS Code standard de réglages ou de raccourcis n’a été trouvé. Les profils alternatifs et les extensions restent à vérifier si VS Code doit être géré.
- Terminal utilise le profil « Clear Dark » au démarrage et par défaut. Finder affiche les barres de chemin et d’état et préfère la vue liste. Le Dock masque les applications récentes. Aucun réglage explicite n’a été lu pour l’automasquage du Dock, l’affichage systématique des fichiers cachés ou des extensions, ni la répétition clavier.

## Reprendre

- Socle Homebrew proposé avec Git, chezmoi, Starship, gh, ShellCheck, pyenv et Poetry. Homebrew fournit Git et pyenv, pyenv sélectionne Python, et Poetry s’exécute indépendamment des environnements des projets.
- Conserver le comportement Homebrew du profil Bash. Prévoir des points d’entrée Bash et Zsh courts, des fonctions et alias compatibles Bash 3.2 et un seul TOML Starship. Premier lot proposé avec `..`, `...`, `ll`, `la` et `mkd`, puis ajout des usages confirmés.
- Git sur SSH avec identité locale, et réglages portables minimalistes. Préserver l’agent SSH existant sur ce Mac. Prévoir le réglage explicite de gh sur SSH et documenter l’authentification du CLI séparément du transport Git.

## Optionnel

| Usage | Casks recensés |
| --- | --- |
| Développement | visual-studio-code |
| Poste et accès | 1password, rectangle, caffeine, anydesk, thebrowsercompany-dia |
| Collaboration et IA | chatgpt, claude, notion, plaud, proton-mail, signal, slack, whatsapp, microsoft-office |
| Synchronisation | dropbox, kdrive, synology-drive |
| Création et médias | blender, spotify, transmission, vlc |

- VS Code ou Vim selon l’usage. Si Vim est retenu, partir de quelques réglages lisibles comme numéros de ligne, recherche et espaces visibles. La recherche d’historique par préfixe de l’ancien `.inputrc` mérite un essai pour Bash. Tmux, clients PostgreSQL, conteneurs, Node.js et autres outils historiques relèvent de besoins de projet à confirmer.
- Préférences Finder et Dock ci-dessus, dans un script utilisateur explicitement déclenché. Garder le profil Terminal local et décider si sa portabilité justifie un export contrôlé. Rectangle est installé et constitue le choix naturel si les raccourcis de fenêtres doivent être repris.
- 1Password facilite la continuité SSH si le coffre est déjà accessible sur le nouveau Mac. Une clé OpenSSH par machine réduit cette dépendance et demande l’enregistrement de chaque clé dans GitHub.

## Laisser de côté

- Bootstrap rsync, scripts Brew avec mises à niveau générales, installation historique pyenv, modules npm globaux, prompt Bash historique, alias Python 2 et chargement implicite de `.env` dans l’ancien flux Poetry. `gmp` ne nécessite pas d’entrée explicite dans le manifeste.
- Réécritures Git vers `git://`, identité et paramètres GPG historiques, exemple de mot de passe dans `.extra`, alias de suppression et opérations système ou réseau inutilisées.
- Déploiement intégral de `.macos` et `.osx`, réglages privilégiés de veille/NVRAM, configuration Spectacle et thèmes Solarized historiques. Écarter l’activation de réglages Vim locaux par projet et les modes historiques `binary` et `noeol`. Mettre de côté les autres configurations anciennes (Screen, Mercurial, GDB, Sublime, GnuPG, curl/wget et scripts de traitement en masse des dépôts) jusqu’à un besoin établi.

## Proposition pour la migration

Utiliser `.chezmoiroot` avec `home/`, et conserver `sourceDir` à la racine du checkout. Les manifestes, scripts et documents restent au même niveau que `home/`. Cette séparation rend le périmètre de déploiement visible et évite de maintenir une liste d’exclusions pour les fichiers de projet. Valider d’abord les cibles et le diff dans un dossier personnel temporaire. Le bootstrap doit pouvoir réutiliser le checkout et la configuration locale après vérification, et distinguer la prévisualisation de l’application. [Documentation chezmoi](https://www.chezmoi.io/user-guide/advanced/customize-your-source-directory/)

Un Brewfile de socle et des manifestes facultatifs effectivement sélectionnables évitent qu’une liste d’applications optionnelles soit installée avec le socle. Homebrew simplifie l’entretien de Poetry et suit le cycle de mises à jour du gestionnaire de paquets. Une installation dédiée à version épinglée reste possible si un projet impose une version du CLI. Activer les `.venv` dans les projets et choisir Python par projet. Sans version activée, le Python système reste disponible. [Configuration de Poetry](https://python-poetry.org/docs/configuration/#virtualenvsin-project)

## Arbitrages avant implémentation

1. Choisir le parcours SSH recommandé sur Mac neuf. Proposition actuelle avec 1Password en parcours principal et OpenSSH par machine en alternative. Confirmer aussi si l’identité Git doit varier entre projets personnels et professionnels.
2. Valider les applications à installer d’emblée et les profils facultatifs à maintenir. Proposition initiale avec un socle CLI et VS Code, Rectangle et 1Password en profils facultatifs, comme les autres casks.
3. Confirmer le petit lot d’alias et l’éditeur principal. Proposition avec configuration Vim minimale si Vim est utilisé et VS Code facultatif.
4. Confirmer les quelques préférences Finder/Dock à reprendre et l’intérêt d’exporter le profil Terminal actuel. Proposition avec un script Finder/Dock facultatif et un profil Terminal laissé local.

Audit réalisé sans application de dotfiles, installation, commit ni accès SSH distant. La recherche indicative de signatures de clés privées et de jetons GitHub/AWS dans HEAD n’a rien relevé. Le contrôle complet du futur diff et de l’historique avant publication reste à faire.
