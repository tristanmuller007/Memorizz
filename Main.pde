import processing.sound.*;

Page gestionnaire;

SoundFile musiqueFond;
SoundFile musiqueEgg;
SoundFile musiqueEnfer;

// Tableau de musiques pour le jeu
SoundFile[] musiquesJeu;
int musiqueJeuActuelle = -1;

void setup() {
  fullScreen(P2D);
  smooth(8);

  try {
    musiqueFond = new SoundFile(this, "musique.mp3");
  }
  catch (Exception e) {
  }
  try {
    musiqueEgg = new SoundFile(this, "DARK_SOULS.mp3");
  }
  catch (Exception e) {
  }
  try {
    musiqueEnfer = new SoundFile(this, "Vordt_of_the_Boreal_Valley.mp3");
  }
  catch (Exception e) {
  }

  // Chargement des musiques de jeu
  chargerMusiquesJeu();

  gestionnaire = new Page(this);
  textAlign(CENTER, CENTER);
  textSize(24);
  frameRate(60);
  noStroke();
}

void chargerMusiquesJeu() {
  ArrayList<SoundFile> listeTemp = new ArrayList<SoundFile>();


  String[] nomsMusiques = {
    "jeu.mp3",
    "jeu2.mp3",
    "jeu3.mp3",
    "jeu4.mp3",
    "jeu5.mp3"
  };

  // Tentative de chargement de chaque fichier
  for (String nom : nomsMusiques) {
    try {
      SoundFile musique = new SoundFile(this, nom);
      listeTemp.add(musique);
      println("Musique chargée : " + nom);
    }
    catch (Exception e) {
      println("Musique non trouvée : " + nom);
    }
  }

  // Conversion en tableau
  if (listeTemp.size() > 0) {
    musiquesJeu = new SoundFile[listeTemp.size()];
    for (int i = 0; i < listeTemp.size(); i++) {
      musiquesJeu[i] = listeTemp.get(i);
    }
    println("" + musiquesJeu.length + " musique(s) de jeu chargée(s)");
  } else {
    println(" Aucune musique de jeu trouvée");
    musiquesJeu = new SoundFile[0];
  }
}


void demarrerMusiqueJeuAleatoire() {
  if (musiquesJeu.length == 0) return;

  // Arrête la musique actuelle si elle joue
  if (musiqueJeuActuelle >= 0 && musiquesJeu[musiqueJeuActuelle].isPlaying()) {
    musiquesJeu[musiqueJeuActuelle].stop();
  }

  // Choisit une nouvelle musique différente de la précédente
  int ancienneMusique = musiqueJeuActuelle;
  do {
    musiqueJeuActuelle = int(random(musiquesJeu.length));
  } while (musiqueJeuActuelle == ancienneMusique && musiquesJeu.length > 1);

  // Lance la nouvelle musique
  musiquesJeu[musiqueJeuActuelle].loop();
  println(" Musique de jeu n°" + (musiqueJeuActuelle + 1) + " lancée");
}

void draw() {
  background(0);
  if (gestionnaire != null) {
    gestionnaire.dessiner();

    // Gestion Volume
    if (gestionnaire.reglages.sonActif) {
      if (musiqueFond != null) musiqueFond.amp(gestionnaire.reglages.volumeSon);
      if (musiqueEgg != null) musiqueEgg.amp(gestionnaire.reglages.volumeSon);
      if (musiqueEnfer != null) musiqueEnfer.amp(gestionnaire.reglages.volumeSon);
      
      // Volume pour toutes les musiques de jeu

      // AJOUT : Volume pour toutes les musiques de jeu
      for (int i = 0; i < musiquesJeu.length; i++) {
        if (musiquesJeu[i] != null) musiquesJeu[i].amp(gestionnaire.reglages.volumeSon);
      }
    }

    // MUSIQUE FOND (Menu, Config, Leaderboard, Settings)
    if ((gestionnaire.etape == 0 || gestionnaire.etape == 1 || gestionnaire.etape == 3 || gestionnaire.etape == 4) && gestionnaire.reglages.sonActif) {
      if (musiqueFond != null && !musiqueFond.isPlaying()) musiqueFond.loop();
      arreterAutresMusiques(musiqueFond);
    }
    // MUSIQUE JEU NORMAL (Aléatoire)
    else if (gestionnaire.etape == 2 && gestionnaire.reglages.sonActif) {

      boolean modeHymne = false;
      if (gestionnaire.jeuMemory != null) {
        modeHymne = gestionnaire.jeuMemory.modeHymne;
      }

      if (modeHymne) {
        arreterToutesLesMusiques();
        println("Musique de fond désactivée ( Mode Hymne)");
      } else {

        // Vérifie si une musique de jeu est en cours
        boolean musiqueEnCours = false;
        if (musiqueJeuActuelle >= 0 && musiqueJeuActuelle < musiquesJeu.length) {
          musiqueEnCours = musiquesJeu[musiqueJeuActuelle].isPlaying();
        }

        // Si aucune musique ne joue, en démarre une aléatoire
        if (!musiqueEnCours) {
          demarrerMusiqueJeuAleatoire();
        }

        arreterAutresMusiques(null); // null = on arrête tout sauf la musique de jeu actuelle
      }
    }
    // MUSIQUE EASTER EGG
    else if (gestionnaire.etape == 5 && gestionnaire.reglages.sonActif) {
      if (musiqueEgg != null && !musiqueEgg.isPlaying()) musiqueEgg.loop();
      arreterAutresMusiques(musiqueEgg);
    }
    // MUSIQUE ENFER
    else if (gestionnaire.etape == 6 && gestionnaire.reglages.sonActif) {
      if (musiqueEnfer != null && !musiqueEnfer.isPlaying()) musiqueEnfer.loop();
      arreterAutresMusiques(musiqueEnfer);
    }
    // PAS DE MUSIQUE
    else {
      arreterToutesLesMusiques();
    }
  }
}


void arreterAutresMusiques(SoundFile musiqueActive) {
  // Arrête musique fond
  if (musiqueFond != null && musiqueActive != musiqueFond && musiqueFond.isPlaying()) {
    musiqueFond.stop();
  }

  // Arrête musiques de jeu (sauf si on est en mode jeu)
  if (musiqueActive != null) { // Si on a une musique active spécifique
    for (int i = 0; i < musiquesJeu.length; i++) {
      if (musiquesJeu[i] != null && musiquesJeu[i].isPlaying()) {
        musiquesJeu[i].stop();
      }
    }
  } else { // Mode jeu : on garde la musique actuelle mais on arrête les autres
    for (int i = 0; i < musiquesJeu.length; i++) {
      if (i != musiqueJeuActuelle && musiquesJeu[i] != null && musiquesJeu[i].isPlaying()) {
        musiquesJeu[i].stop();
      }
    }
  }

  // Arrête Easter Egg
  if (musiqueEgg != null && musiqueActive != musiqueEgg && musiqueEgg.isPlaying()) {
    musiqueEgg.stop();
  }

  // Arrête Enfer
  if (musiqueEnfer != null && musiqueActive != musiqueEnfer && musiqueEnfer.isPlaying()) {
    musiqueEnfer.stop();
  }
}

// Arrête toutes les musiques
void arreterToutesLesMusiques() {
  if (musiqueFond != null && musiqueFond.isPlaying()) musiqueFond.stop();

  // Arrête toutes les musiques de jeu
  for (int i = 0; i < musiquesJeu.length; i++) {
    if (musiquesJeu[i] != null && musiquesJeu[i].isPlaying()) {
      musiquesJeu[i].stop();
    }
  }

  if (musiqueEgg != null && musiqueEgg.isPlaying()) musiqueEgg.stop();
  if (musiqueEnfer != null && musiqueEnfer.isPlaying()) musiqueEnfer.stop();

  musiqueJeuActuelle = -1; // Reset de l'index
}

void mousePressed() {
  if (gestionnaire != null) gestionnaire.gererClic();
}

void mouseDragged() {
  if (gestionnaire != null) gestionnaire.gererDrag();
}

void keyPressed() {
  if (gestionnaire != null) gestionnaire.gererTouche();
}
