# Décisions de configuration

| Décision | Raison et alternative examinée |
| --- | --- |
| Conserver `git@github.com:ebreton/dotfiles.git` et son historique. Travailler sur `modernize/chezmoi-starship`. | L’historique garde la trace de l’ancienne configuration. Le bootstrap actuel réutilise le checkout. |
| Gérer les fichiers personnels avec chezmoi et `.chezmoiroot` dans `home/`. | Le manifeste, le README et les scripts restent en dehors des cibles. Le remplacement du bootstrap rsync permet de prévisualiser les changements. |
| Conserver Bash 3.2 et préparer Zsh avec un prompt Starship commun. | Une migration du shell de connexion peut intervenir séparément. Les fichiers communs utilisent des constructions compatibles avec les deux shells. |
| Installer Git et pyenv via Homebrew et choisir Python par projet. Gérer Poetry manuellement avec les versions Python installées par pyenv. | L’installation et la configuration de Poetry relèvent des besoins de chaque projet. |
| Utiliser l’agent 1Password pour SSH et une seule identité GitHub. | Le parcours reprend l’agent déjà configuré. L’identité et l’accès CLI restent configurés localement. |
| Installer les applications courantes par défaut et rendre les outils de développement supplémentaires optionnels. | Le socle CLI et Python restent nécessaires au poste. VS Code est proposé dans le manifeste de développement. |
| Choisir VS Code comme éditeur et écarter le Vim historique. | Le terminal sélectionne `code --wait` quand la commande est disponible et qu’aucun éditeur n’est déjà défini. |
| Reprendre les réglages Finder et Dock observés dans un script facultatif. | Les opérations sont limitées à quatre préférences utilisateur. Le profil Terminal Clear Dark reste local. |

## Personnalisations retenues

Initialisation de Homebrew, raccourcis de navigation et de liste, fonction `mkd`, Git SSH et agent 1Password, barres de chemin et d’état du Finder, vue liste et masquage des applications récentes du Dock.

## Configurations écartées du déploiement

Prompt Bash historique, chargeur implicite de `.env`, réécritures Git historiques, paramètres Vim, personnalisation macOS globale, scripts d’installation historiques et installations Node globales. Les anciens fichiers ont été retirés de la branche après validation explicite. Ils restent consultables dans l’historique au commit `a6cbf6b`.

## Vérification

- Syntaxe contrôlée avec Bash 3.2, Zsh 5.9 et ShellCheck pour les fichiers compatibles.
- Cibles inspectées avec `chezmoi managed`. Le plan du Mac courant a été examiné en lecture seule. Dans un dossier personnel temporaire, deux applications successives ont abouti à un diff vide et à un `chezmoi verify` réussi.
- Les modes `plan`, `install` et `apply` ont été exercés dans un checkout temporaire. Les appels Homebrew ont été simulés. Les tests ont vérifié la sélection des manifestes, l’initialisation de `sourceDir`, la conservation d’une identité Git et d’un include existants, l’absence de doublon et le transport SSH de gh.
- Les démarrages Bash et Zsh ont été exercés en mode interactif et en connexion non interactive avec un exécutable de test pour pyenv. Les appels d’initialisation, la priorité des shims, l’éditeur et la fonction `mkd` ont été contrôlés. Starship a rendu un prompt réel avec état Git, virtualenv et code d’erreur.
- La recherche indicative de signatures de clés privées et de jetons GitHub/AWS a couvert l’arbre de travail et l’historique Git local. Une revue du diff destiné à la publication reste nécessaire.
- Restent à vérifier sur un Mac avec autorisation d’installation : la résolution et l’installation de tous les paquets, Git Homebrew, et l’installation d’un Python par pyenv. L’authentification GitHub avec 1Password et l’application des préférences macOS restent également à tester. Aucun de ces changements n’a été appliqué au Mac courant.
