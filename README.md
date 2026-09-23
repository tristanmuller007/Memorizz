# Memorizz - Jeu de memory en Processing

## Contexte

Projet réalisé en **BUT Informatique (1re année)** à l'**IUT Lyon 1 - site de Bourg-en-Bresse**.

L'objectif était de développer une **application graphique complète en Processing (Java)** à partir d'un jeu simple, le memory, en y ajoutant de vraies fonctionnalités : plusieurs modes de jeu, des thèmes, un classement, des paramètres et une interface soignée.

---

## Présentation du projet

**Memorizz** est un jeu de memory éducatif qui permet de tester ses connaissances sur les **drapeaux, les pays, les capitales et les hymnes nationaux**, avec d'autres thématiques (animaux, gastronomie, marques, histoire...).

Le joueur choisit une thématique et une difficulté, retourne les cartes par paires, et son score (nombre de coups et temps) est enregistré dans un classement.

---

## Objectifs pédagogiques

- Concevoir une application en **programmation orientée objet**
- Organiser le code en **classes** avec des responsabilités séparées
- Gérer une **navigation entre plusieurs écrans**
- Manipuler des **ressources** (images, sons, fichiers texte)
- Lire et écrire des **données persistantes** (scores)

---

## Fonctionnalités

### Jeu
- **3 niveaux de difficulté** : Facile (16 cartes), Moyen (24 cartes), Expert (36 cartes)
- **Plusieurs thématiques** : géographie (drapeaux, pays, hymnes), animaux, gastronomie, marques, histoire, mode libre
- Compteur de **coups** et de temps
- **Musiques** de fond choisies aléatoirement pendant la partie

### Mode Enfer
- Mode bonus plus difficile : les **cartes se mélangent toutes les 5 secondes**
- Écran de fin et dialogues dédiés

### Interface
- Écran de **chargement** animé
- Page d'**accueil**, choix de la partie, **paramètres**
- **Classement** (leaderboard) avec saisie du nom du joueur, sauvegardé dans un fichier
- **Bilingue** français / anglais
- **Mode sombre** et option d'**accessibilité**
- Un **easter egg** caché

---

## Organisation du code

Le projet compte environ **4 500 lignes** de Processing, réparties en classes :

| Fichier | Rôle |
|---|---|
| `Memorizz.pde` | Point d'entrée, chargement des musiques |
| `Page.pde` | Gestionnaire de navigation entre les écrans |
| `Chargement.pde` | Écran de chargement |
| `Acceuil.pde` | Page d'accueil |
| `ChoixGame.pde` | Choix de la thématique et de la difficulté |
| `Memory_Jeu.pde` | Logique du jeu de memory |
| `Carte.pde` | Classe représentant une carte |
| `MemoryEnfer.pde`, `EcranFinEnfer.pde`, `Dialogue.pde` | Mode Enfer |
| `Leaderboard.pde` | Classement et sauvegarde des scores |
| `Parametre.pde` | Langue, mode sombre, accessibilité |
| `BibliothequeImagesSons.pde` | Chargement des images et des sons |
| `PageEasterEgg.pde` | Easter egg |

Les ressources (images, sons, scores) sont dans le dossier `data/`.

---

## Lancer le projet

1. Installer [Processing 4](https://processing.org/download)
2. Installer la librairie **Sound** : *Sketch > Import Library > Manage Libraries > Sound*
3. Ouvrir `Memorizz.pde` et cliquer sur **Run**

---

## Suite du projet

- ajouter de nouvelles thématiques
- mode deux joueurs
- export du jeu en application autonome (Windows / macOS)

---

## Auteur

**Tristan Muller** - BUT Informatique, IUT Lyon 1 (Bourg-en-Bresse)
[Portfolio](https://tristanmuller007.github.io/Portfolio/) · [GitHub](https://github.com/tristanmuller007)
