# Dotfiles macOS

Ce dépôt public aide à configurer un Mac neuf ou un poste macOS existant avec Homebrew et chezmoi. Il fournit des réglages pour Bash et Zsh et un prompt Starship commun. Le shell de connexion déjà choisi sur le Mac est conservé.

| Emplacement | Rôle |
| --- | --- |
| `home/` | Sources chezmoi, sélectionnées par `.chezmoiroot` |
| `Brewfile` | Socle CLI et applications courantes |
| `brew/Brewfile.development` | Outils de développement facultatifs, dont iTerm2 et VS Code |
| `bootstrap.sh` | Prévisualisation, installation et déploiement |
| `scripts/` | Diagnostic et préférences macOS facultatives |
| [`docs/DECISIONS.md`](docs/DECISIONS.md) | Décisions, arbitrages et état des vérifications |

Le répertoire `.audit/` est privé et ignoré par Git.

## Configurer votre Mac

### Outils Apple et Homebrew

Ouvrez l’application Terminal. Vérifiez les outils Apple avec `xcode-select -p`. S’ils sont absents, lancez `xcode-select --install` et attendez la fin de l’installation. Si Homebrew est absent, suivez la procédure officielle. [Homebrew](https://brew.sh/)

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv bash)"
# Sur Mac Intel, utiliser /usr/local/bin/brew.
brew install git chezmoi
git --version
command -v git
```

### Accès au dépôt public et clonage SSH

Vous pouvez lire le dépôt dans un navigateur sans compte ni invitation. Pour le cloner en SSH, utilisez votre propre compte GitHub et une clé publique enregistrée sur ce compte. L’accès à des dépôts d’organisation se demande séparément.

- Avec 1Password, installez au besoin `brew install --cask 1password`, ouvrez votre coffre et activez l’agent SSH. Fusionnez ses réglages avec votre éventuel `~/.ssh/config`. [Guide 1Password pour SSH](https://developer.1password.com/docs/ssh/get-started/)
- Avec l’agent OpenSSH, utilisez une clé existante ou créez-en une et ajoutez sa partie publique à votre compte. [Configuration SSH dans GitHub](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh)
- Au premier accès, vérifiez l’empreinte du serveur. `ssh -T git@github.com` doit afficher votre nom d’utilisateur GitHub. GitHub utilise normalement le code de sortie 1 pour ce test réussi. [Empreintes SSH officielles](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)

```bash
mkdir -p "$HOME/code"
git clone git@github.com:ebreton/dotfiles.git "$HOME/code/dotfiles"
cd "$HOME/code/dotfiles"
```

Le chemin est un exemple. Vous pouvez utiliser un autre dossier ou reprendre un checkout existant après avoir vérifié sa branche et son remote avec `git status -sb` et `git remote -v`.

### Installation et déploiement

```bash
./bootstrap.sh plan
./bootstrap.sh install
./bootstrap.sh plan
./bootstrap.sh apply
```

Pour ajouter iTerm2 et VS Code, utilisez `./bootstrap.sh plan --development` et `./bootstrap.sh install --development` aux étapes de sélection et d’installation. Consultez le [Brewfile](Brewfile) pour connaître les applications du parcours standard. L’installation conserve les paquets présents et ne force pas leur mise à niveau. L’accès aux services, les licences et les autorisations macOS se règlent dans les applications concernées.

Le bootstrap associe chezmoi au checkout courant. Si vous utilisez déjà chezmoi avec un autre dépôt, examinez sa configuration avec `chezmoi edit-config` avant de modifier `sourceDir`. Relisez le second plan avant `apply`, surtout si vous avez déjà des dotfiles personnalisés.

Si vous créez des commits, définissez votre propre identité Git avec `git config --global user.name 'Prénom Nom'` et `git config --global user.email 'adresse GitHub ou noreply'`. Pour utiliser GitHub CLI, vous pouvez vous connecter séparément avec `gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key`. Le bootstrap configure le protocole Git de gh pour GitHub.

### Shell et éditeur

Ouvrir un nouveau Terminal ou lancer `exec /bin/bash -l`. Essayer Zsh avec `/bin/zsh -l`. Les deux shells partagent les alias `..`, `...`, `ll`, `la`, la fonction `mkd` et la configuration Starship dans `~/.config`. Choisir un terminal avec UTF-8 pour afficher le prompt.

VS Code est l’éditeur de référence. Si `code` est absent du PATH, utiliser la palette VS Code, commande **Shell Command: Install 'code' command in PATH**. Dans un nouveau shell, `EDITOR` prend alors la valeur `code --wait` s’il n’a pas déjà été défini. Utiliser Settings Sync de VS Code si le partage de ses réglages et extensions est souhaité.

Chezmoi déploie le profil iTerm2 **Dotfiles** dans `~/Library/Application Support/iTerm2/DynamicProfiles`. Pendant `./bootstrap.sh apply`, le script sélectionne **Dotfiles** comme profil par défaut pour les nouvelles sessions et désactive la confirmation de `⌘Q`. Ce profil lance le shell de connexion, active l’intégration shell automatique et conserve 10 000 lignes de défilement. Il hérite des couleurs et de la police du profil par défaut. Les alias et Starship sont chargés par les fichiers de démarrage habituels. [Profils dynamiques](https://iterm2.com/documentation-dynamic-profiles.html) · [Intégration shell](https://iterm2.com/documentation-shell-integration.html)

Si iTerm2 est ouvert au moment du changement, termine tes sessions, quitte iTerm2, puis exécute `./scripts/iterm2-preferences.sh` depuis Terminal. Rouvre iTerm2 pour utiliser les nouveaux réglages. [Préférences iTerm2](https://iterm2.com/documentation-preferences-general.html)

Pour faire évoluer ce profil, modifier [son JSON](home/private_Library/private_Application%20Support/iTerm2/DynamicProfiles/dotfiles.json) en conservant son `Guid`, puis appliquer les dotfiles. iTerm2 recharge le fichier automatiquement. Le profil distingue les couleurs des modes clair et sombre. iTerm2 peut aussi réécrire le JSON lorsque tu modifies le profil dans son interface. `./scripts/diagnose.sh` compare alors le fichier local à la version du dépôt et indique comment afficher les écarts avant de relancer un déploiement. Les préfixes `private_` dans les sources chezmoi donnent à `~/Library` et à `~/Library/Application Support` les permissions `0700`.

### Python

Homebrew installe pyenv et `xz`, qui fournit la bibliothèque utilisée par le module Python `lzma`. Choisir une version Python adaptée au projet, sans définir de version globale imposée.

```bash
pyenv install --list
# Remplacer X.Y.Z par la version du projet.
pyenv install -s X.Y.Z
cd /chemin/du/projet
pyenv local X.Y.Z
python --version
```

Les deux shells chargent les shims pyenv. Si un projet utilise Poetry, gérer son installation et sa configuration manuellement avec la version Python sélectionnée par pyenv. Starship affiche le virtualenv lorsqu’il est activé.

### Préférences macOS et validation

```bash
./scripts/macos-preferences.sh --preview
# À exécuter seulement si les réglages proposés sont souhaités.
./scripts/macos-preferences.sh --apply

./scripts/diagnose.sh
chezmoi managed
chezmoi diff
chezmoi verify
gh config get git_protocol --host github.com
```

`--preview` lit les valeurs actuelles et signale celles qui changeraient. `--apply` écrit les écarts, relit chaque valeur modifiée et redémarre le Finder ou le Dock si ses réglages ont changé.

La vue liste est la préférence générale du Finder. Si un dossier conserve une autre vue, ouvre ses options de présentation avec `⌘J` et vérifie le réglage « Toujours ouvrir en ». [Guide Apple du Finder](https://support.apple.com/fr-fr/guide/mac-help/mchldaafb302/mac)

Le profil Terminal Clear Dark reste un réglage local.

## Maintenance et synchronisation

- Pour modifier un fichier existant, utiliser `chezmoi edit ~/.config/starship.toml`, puis examiner `chezmoi diff` avant `chezmoi apply`.
- Pour ajouter un fichier, examiner son contenu et utiliser `chezmoi add ~/chemin/du/fichier`. Relire le diff Git, notamment l’identité, les chemins personnels et les secrets, avant de committer.
- Publier les commits volontairement via SSH après validation. Sur un autre Mac, mettre à jour la même branche avec `git pull --ff-only`, puis relire `./bootstrap.sh plan`. Relancer `install` si les manifestes ont changé et `apply` après revue.
- Mettre à jour Homebrew et ses paquets séparément avec `brew update`, `brew outdated` et des mises à jour ciblées. Relancer le diagnostic après un changement de shell ou de version Python.

## Dépannage

### Chezmoi signale que le modèle de configuration a changé

L’avertissement `config file template has changed, run chezmoi init to regenerate config file` indique que la configuration locale est antérieure au modèle du dépôt. Depuis la racine du checkout, régénérer cette configuration avec la commande suivante.

```bash
chezmoi --source "$PWD" init
```

Cette commande régénère le fichier de configuration sans appliquer les dotfiles. Si tu as ajouté des réglages locaux à `~/.config/chezmoi/chezmoi.toml`, sauvegarde ce fichier avant la régénération et reporte tes réglages ensuite. Relance `./bootstrap.sh plan`, puis `./bootstrap.sh apply` si le diff correspond à ce que tu souhaites appliquer.

### Python compilé sans `_lzma`

Si `pyenv install` signale `The Python lzma extension was not compiled`, installe `xz` puis recompile la version exacte concernée. Le message `use zlib from xcode sdk` est informatif et concerne une autre bibliothèque.

```bash
brew install xz
pyenv install --force 3.14.10
PYENV_VERSION=3.14.10 pyenv exec python -c 'import lzma; print(lzma.decompress(lzma.compress(b"ok")).decode())'
```

Remplace `3.14.10` par la version indiquée dans ton avertissement. La recompilation vise une installation existante. Avant de la lancer, assure-toi de pouvoir réinstaller les paquets et recréer les environnements qui en dépendent. Le test doit afficher `ok`.

### Autres cas

| Symptôme | Vérification |
| --- | --- |
| Git système prioritaire | Ouvrir un shell de connexion et vérifier `type -a git` et le résultat de `brew shellenv bash`. |
| Refus SSH | Déverrouiller 1Password, vérifier la clé publique dans GitHub et le réglage d’agent avec `ssh -G github.com`. |
| Chezmoi pointe ailleurs | Vérifier le chemin avec `./scripts/diagnose.sh` et corriger `sourceDir` localement. |
| Python reste système | Exécuter `pyenv version` et `pyenv which python3` depuis le projet. Installer la version attendue si elle manque. |
| Prompt absent | Vérifier `command -v starship`, `STARSHIP_CONFIG` et le type de terminal. |
| Conflit d’installation d’une application | Vérifier si une copie indépendante existe dans Applications. Préserver ses données et résoudre le conflit individuellement. |

## Origine et licence

Le dépôt descend des [dotfiles de Mathias Bynens](https://github.com/mathiasbynens/dotfiles). La configuration historique reste consultable dans Git au commit `a6cbf6b`. La [licence MIT](LICENSE-MIT.txt) est conservée.
