# Dotfiles macOS

Configuration d’un poste macOS avec Homebrew, chezmoi, Bash et Zsh. Bash reste le shell de connexion. Starship utilise le même prompt dans les deux shells.

| Emplacement | Rôle |
| --- | --- |
| `home/` | Sources chezmoi, sélectionnées par `.chezmoiroot` |
| `Brewfile` | Socle CLI et applications courantes |
| `brew/Brewfile.development` | Outils de développement facultatifs, actuellement VS Code |
| `bootstrap.sh` | Prévisualisation, installation et déploiement |
| `scripts/` | Diagnostic et préférences macOS facultatives |
| [`docs/DECISIONS.md`](docs/DECISIONS.md) | Décisions, arbitrages et état des vérifications |

Le répertoire `.audit/` est privé et ignoré par Git.

## Nouveau Mac

### Outils Apple et Homebrew

Vérifier `xcode-select -p`. Si les outils sont absents, lancer `xcode-select --install` puis attendre l’installation. Installer Homebrew avec la commande officielle publiée sur [brew.sh](https://brew.sh/). Charger son environnement dans le terminal courant.

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv bash)"
# Sur Mac Intel, utiliser /usr/local/bin/brew.
brew install git chezmoi
git --version
command -v git
```

### SSH avec 1Password et clonage

1. Installer `brew install --cask 1password`, ouvrir l’application et se connecter au coffre. Activer l’agent SSH dans les paramètres de développement.
2. Configurer OpenSSH pour cet agent selon la [documentation 1Password](https://developer.1password.com/docs/ssh/get-started/). Fusionner ce réglage avec un éventuel `~/.ssh/config`. Vérifier que la clé publique correspondante est enregistrée dans GitHub. L’agent, ses clés et les données de connexion restent locaux.
3. Vérifier l’empreinte d’hôte affichée avec les [empreintes officielles GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints), puis tester `ssh -T git@github.com`. GitHub affiche le compte authentifié et retourne normalement 1 pour ce test réussi.

```bash
mkdir -p ~/code/ebreton
git clone git@github.com:ebreton/dotfiles.git ~/code/ebreton/dotfiles
cd ~/code/ebreton/dotfiles
# Jusqu’à l’intégration de la migration à la branche par défaut.
git switch modernize/chezmoi-starship
```

Cette branche doit être publiée avant de pouvoir la cloner sur un autre Mac. Si le checkout existe déjà, vérifier sa branche et son remote avec `git status -sb` et `git remote -v`.

### Installation et déploiement

```bash
./bootstrap.sh plan --development
./bootstrap.sh install --development
./bootstrap.sh plan
./bootstrap.sh apply
```

Sans `--development`, `install` installe seulement le socle et les applications du Brewfile principal. L’installation conserve les paquets déjà présents et ne force pas leurs mises à niveau. Homebrew suit les versions disponibles au moment de l’installation. L’accès aux services, les licences, les connexions aux applications et les autorisations macOS sont effectués dans les applications concernées.

Le bootstrap réutilise le checkout courant, crée la configuration chezmoi si nécessaire et vérifie son emplacement. Si une autre configuration chezmoi existe, examiner `chezmoi edit-config` avant de définir `sourceDir` sur le chemin absolu du checkout. Le plan affiche le diff des fichiers gérés. Examiner les éventuelles personnalisations à fusionner avant `apply`. Pour Git, le bootstrap ajoute un include portable en conservant les autres entrées existantes. Il règle aussi le transport Git de `gh` pour `github.com`.

Configurer une fois l’identité locale avec `git config --global user.name 'Prénom Nom'` et `git config --global user.email 'adresse GitHub ou noreply'`. Pour utiliser l’API et les commandes GitHub CLI, effectuer séparément `gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key`. La connexion SSH utilise la clé déjà enregistrée dans GitHub. L’accès API de gh utilise sa propre authentification.

### Shell et éditeur

Ouvrir un nouveau Terminal ou lancer `exec /bin/bash -l`. Essayer Zsh avec `/bin/zsh -l`. Les deux shells partagent les alias `..`, `...`, `ll`, `la`, la fonction `mkd` et la configuration Starship dans `~/.config`. Choisir un terminal avec UTF-8 pour afficher le prompt.

VS Code est l’éditeur de référence. Si `code` est absent du PATH, utiliser la palette VS Code, commande **Shell Command: Install 'code' command in PATH**. Dans un nouveau shell, `EDITOR` prend alors la valeur `code --wait` s’il n’a pas déjà été défini. Utiliser Settings Sync de VS Code si le partage de ses réglages et extensions est souhaité.

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

Le script facultatif règle les barres et la vue du Finder ainsi que les applications récentes du Dock. Le profil Terminal Clear Dark reste un réglage local.

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
