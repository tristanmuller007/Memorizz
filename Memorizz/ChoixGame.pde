class ChoixGame {

  // Référence aux paramètres globaux (mode sombre, langue, etc.)
  Parametres reglages;

  // Largeur d'une colonne de sélection (calculée selon la largeur de l'écran)
  float largeurColonne;

  // Listes de données pour les différentes étapes de sélection
  String[] listeThematiques = {"PAYS", "GEOGRAPHIE", "LIBRE"};
  String[] listePays = {};
  String[] listeSousThemes = {};
  String[] listeDifficultes = {"FACILE (16)", "MOYEN (24)", "EXPERT (36)"};

  // Indices de sélection actuelle (-1 indique que rien n'est choisi)
  int indexThematiqueSelectionnee = -1;
  int indexPaysSelectionne = -1;
  int indexSousThemeSelectionne = -1;
  int indexDifficulteSelectionnee = -1;

  // Signal pour indiquer au moteur principal de démarrer la partie
  boolean lancementJeuDemande = false;

  color couleurFondHaut = color(5, 10, 20);
  color couleurFondBas = color(15, 25, 45);
  color couleurAccentuation = color(0, 210, 255);

  // Système de particules pour l'arrière-plan animé
  float[] particuleX = new float[25];
  float[] particuleY = new float[25];
  float[] particuleTaille = new float[25];

  // Initialise les paramètres et les particules d'arrière-plan
  ChoixGame(Parametres r) {
    this.reglages = r;

    for (int i = 0; i < 25; i++) {
      particuleX[i] = random(width);
      particuleY[i] = random(height);
      particuleTaille[i] = random(10, 40);
    }
  }

  // Gère le rendu complet de l'interface utilisateur
  void afficherInterface(boolean anglais) {
    this.largeurColonne = width / 3.0;

    // Rendu du fond selon les réglages (Sombre / Clair)
    if (reglages.modeSombre) {
      dessinerArrierePlanAnime();
    } else {
      background(240);
      for (int i = 0; i < 25; i++) {
        fill(0, 210, 255, 15);
        noStroke();
        rect(particuleX[i], particuleY[i], particuleTaille[i], particuleTaille[i], 4);
        particuleY[i] -= 0.3;
        if (particuleY[i] < -50) particuleY[i] = height + 50;
      }
    }

    // Affichage du titre principal
    pushMatrix();
    translate(0, 0, 1);
    textAlign(CENTER, TOP);
    fill(couleurAccentuation);
    textSize(width * 0.025);
    text(anglais ? "GAME CONFIGURATION" : "CONFIGURATION DU JEU", width / 2, 40);
    popMatrix();

    dessinerBoutonRetour();
    boolean survolBouton = false;

    // Colonne 1 : Sélection du sujet 
    if (indexThematiqueSelectionnee != -1 && listePays.length > 0) {
      dessinerTitreColonne(anglais ? "SUB-THEME" : "PAYS / SUJET", 0);
      if (dessinerListeBoutons(listePays, 0, indexPaysSelectionne, anglais)) survolBouton = true;
    }

    // Colonne 2 : Sélection de la Catégorie
    if (indexPaysSelectionne != -1) {
      dessinerLigneSeparationNeon(largeurColonne);
      dessinerTitreColonne(anglais ? "CATEGORY" : "CATÉGORIE", 1);
      if (dessinerListeBoutons(listeSousThemes, 1, indexSousThemeSelectionne, anglais)) survolBouton = true;
    }

    // Colonne 3 : Sélection de la Difficulté
    if (indexSousThemeSelectionne != -1) {
      dessinerLigneSeparationNeon(largeurColonne * 2);
      dessinerTitreColonne(anglais ? "DIFFICULTY" : "DIFFICULTÉ", 2);
      if (dessinerListeBoutons(listeDifficultes, 2, indexDifficulteSelectionnee, anglais)) survolBouton = true;
    }

    dessinerBarreStatutBas();

    // Affichage du bouton final si la configuration est complète
    if (indexDifficulteSelectionnee != -1) {
      dessinerBoutonLancement(anglais);
    }

    // Gestion du curseur (Main ou Flèche)
    if (survolBouton || dist(mouseX, mouseY, 50, 50) < 25 ||
      (indexDifficulteSelectionnee != -1 && mouseX > width / 2 - 125 && mouseX < width / 2 + 125 &&
      mouseY > height - 165 && mouseY < height - 105)) {
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
  }

  // Dessine le fond dégradé avec les particules montantes
  void dessinerArrierePlanAnime() {
    for (int i = 0; i <= height; i += 4) {
      stroke(lerpColor(couleurFondHaut, couleurFondBas, map(i, 0, height, 0, 1)));
      strokeWeight(4);
      line(0, i, width, i);
    }

    noStroke();
    for (int i = 0; i < 25; i++) {
      fill(couleurAccentuation, 10);
      rect(particuleX[i], particuleY[i], particuleTaille[i], particuleTaille[i], 4);
      particuleY[i] -= 0.3;
      if (particuleY[i] < -50) particuleY[i] = height + 50;
    }
  }

  // Ligne verticale lumineuse entre les colonnes
  void dessinerLigneSeparationNeon(float xPos) {
    for (int i = 0; i < 5; i++) {
      stroke(couleurAccentuation, 30 - i * 10);
      strokeWeight(i + 3);
      line(xPos, 180, xPos, height - 180);
    }
  }

  // Petit bouton pour revenir en arrière
  void dessinerBoutonRetour() {
    float x = 50, y = 50;
    boolean survol = dist(mouseX, mouseY, x, y) < 25;

    pushMatrix();
    translate(x, y);
    if (survol) scale(1.1);

    noFill();
    stroke(couleurAccentuation);
    strokeWeight(2);
    ellipse(0, 0, 40, 40);

    line(5, 0, -5, 0); 
    line(-5, 0, 0, -5);
    line(-5, 0, 0, 5);

    popMatrix();
  }

  // Panneau du bas affichant la progression des choix
  void dessinerBarreStatutBas() {
    float hauteurPanel = 80;
    fill(0, 180);
    noStroke();
    rect(0, height - hauteurPanel, width, hauteurPanel);

    stroke(couleurAccentuation, 80);
    strokeWeight(1);
    line(0, height - hauteurPanel, width, height - hauteurPanel);

    dessinerPointProgression(width * 0.25, height - 40, "PAYS", indexPaysSelectionne != -1);
    dessinerPointProgression(width * 0.5, height - 40, "CATÉGORIE", indexSousThemeSelectionne != -1);
    dessinerPointProgression(width * 0.75, height - 40, "NIVEAU", indexDifficulteSelectionnee != -1);
  }

  // Dessine un point lumineux si l'étape est validée
  void dessinerPointProgression(float x, float y, String etiquette, boolean estActif) {
    pushMatrix();
    translate(0, 0, 1);
    textAlign(CENTER);
    textSize(12);
    fill(estActif ? couleurAccentuation : 80);
    text(etiquette, x, y - 20);
    popMatrix();

    if (estActif) {
      noStroke();
      for (int i = 0; i < 5; i++) {
        fill(couleurAccentuation, 40 - i * 8);
        ellipse(x, y, 10 + i * 2, 10 + i * 2);
      }
    }
    fill(estActif ? couleurAccentuation : 40);
    noStroke();
    ellipse(x, y, 8, 8);
  }

  // Bouton de validation final avec effet de lueur pulsée
  void dessinerBoutonLancement(boolean anglais) {
    float xBouton = width / 2;
    float yBouton = height - 135;

    pushMatrix();
    translate(xBouton, yBouton);

    boolean sourisSurBouton = (mouseX > xBouton - 125 && mouseX < xBouton + 125 && mouseY > yBouton - 30 && mouseY < yBouton + 30);
    if (sourisSurBouton) scale(1.05);

    rectMode(CENTER);
    for (int i = 10; i > 0; i--) {
      fill(couleurAccentuation, 10 - i);
      rect(0, 0, 250 + i * 4, 60 + i * 4, 20);
    }

    fill(couleurAccentuation);
    rect(0, 0, 250, 60, 15);

    fill(couleurFondHaut);
    textSize(22);
    textAlign(CENTER, CENTER);
    text(anglais ? "START GAME" : "LANCER LE JEU", 0, -3);
    popMatrix();
    rectMode(CORNER);
  }

  // Gère l'affichage des boutons dans chaque colonne et leurs traductions
  boolean dessinerListeBoutons(String[] contenu, int numColonne, int indexSelection, boolean anglais) {
    boolean survol = false;
    for (int i = 0; i < contenu.length; i++) {
      float x = numColonne * largeurColonne + 60;
      float y = 200 + (i * 90);
      float w = largeurColonne - 120;
      float h = 60;
      boolean sourisSurLigne = (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
      if (sourisSurLigne) survol = true;

      pushMatrix();
      if (sourisSurLigne && i != indexSelection) {
        translate(x + w / 2, y + h / 2);
        scale(1.08);
        translate(-(x + w / 2), -(y + h / 2));
      }

      // Dessin du rectangle du bouton
      if (i == indexSelection) {
        fill(couleurAccentuation);
        stroke(255);
        strokeWeight(3);
      } else {
        fill(reglages.modeSombre ? color(60, 90, 130) : color(200, 220, 240));
        if (!sourisSurLigne) fill(reglages.modeSombre ? color(20, 30, 50, 180) : color(255, 255, 255, 200));
        stroke(sourisSurLigne ? color(0, 210, 255, 255) : color(0, 210, 255, 100));
        strokeWeight(sourisSurLigne ? 2.5 : 1.5);
      }
      rect(x, y, w, h, 8);
      popMatrix();

      // Traduction dynamique du texte selon la langue sélectionnée
      String texteAffiche = contenu[i];
      if (anglais && numColonne == 0) {
        if (texteAffiche.equals("La France")) texteAffiche = "France";
        else if (texteAffiche.equals("L'Allemagne")) texteAffiche = "Germany";
        else if (texteAffiche.equals("La Turquie")) texteAffiche = "Turkey";
        else if (texteAffiche.equals("PAYS")) texteAffiche = "COUNTRY";
      }

      if (anglais && numColonne == 1) {
        if (texteAffiche.equals("GASTRONOMIE")) texteAffiche = "FOOD";
        else if (texteAffiche.equals("MARQUES")) texteAffiche = "BRANDS";
        else if (texteAffiche.equals("HISTOIRE")) texteAffiche = "HISTORY";
        else if (texteAffiche.equals("HYMNE")) texteAffiche = "ANTHEM";
        else if (texteAffiche.equals("DRAPEAU")) texteAffiche = "FLAG";
        else if (texteAffiche.equals("PAYSAGE")) texteAffiche = "LANDSCAPE";
      }

      if (anglais && numColonne == 2) {
        if (texteAffiche.equals("FACILE (16)")) texteAffiche = "EASY (16)";
        else if (texteAffiche.equals("MOYEN (24)")) texteAffiche = "MEDIUM (24)";
        else if (texteAffiche.equals("EXPERT (36)")) texteAffiche = "EXPERT (36)";
      }

      // Texte à l'intérieur du bouton
      pushMatrix();
      translate(0, 0, 1);
      fill(i == indexSelection ? couleurFondHaut : (sourisSurLigne ? (reglages.modeSombre ? 255 : 0) : (reglages.modeSombre ? 200 : 60)));
      textSize(sourisSurLigne ? 18 : 16);
      textAlign(CENTER, CENTER);
      text(texteAffiche, x + w / 2, y + h / 2);
      popMatrix();
    }
    return survol;
  }

  // Affiche le sous-titre de chaque colonne
  void dessinerTitreColonne(String titre, int numColonne) {
    pushMatrix();
    translate(0, 0, 1);
    fill(couleurAccentuation, 220);
    textSize(18);
    textAlign(CENTER);
    text(titre, numColonne * largeurColonne + largeurColonne / 2, 170);
    popMatrix();
  }

  // Gère la logique de sélection lors d'un clic
  void gererClicSouris(int mX, int mY) {
    int colonneCliquee = (int)(mX / largeurColonne);
    int indexBoutonClique = (int)((mY - 200) / 90);

    boolean dansZoneListe = (mY > 200 && mY < height - 180);

    // Clic sur le bouton de lancement
    if (!dansZoneListe) {
      if (indexDifficulteSelectionnee != -1) {
        float xBouton = width / 2;
        float yBouton = height - 135;
        if (mX > xBouton - 125 && mX < xBouton + 125 && mY > yBouton - 30 && mY < yBouton + 30) {
          lancerJeu();
        }
      }
      return;
    }

    // Gestion de la cascade des sélections
    if (indexThematiqueSelectionnee != -1 && colonneCliquee == 0 && indexBoutonClique >= 0 && indexBoutonClique < listePays.length) {
      indexPaysSelectionne = indexBoutonClique;
      indexSousThemeSelectionne = -1;
      indexDifficulteSelectionnee = -1;
      mettreAJourSousThemes(listeThematiques[indexThematiqueSelectionnee], listePays[indexBoutonClique]);
    } else if (indexPaysSelectionne != -1 && colonneCliquee == 1 && indexBoutonClique >= 0 && indexBoutonClique < listeSousThemes.length) {
      indexSousThemeSelectionne = indexBoutonClique;
      indexDifficulteSelectionnee = -1;
    } else if (indexSousThemeSelectionne != -1 && colonneCliquee == 2 && indexBoutonClique >= 0 && indexBoutonClique < listeDifficultes.length) {
      indexDifficulteSelectionnee = indexBoutonClique;
    }
  }

  // Vérifie si l'utilisateur clique sur le bouton retour
  boolean clicSurRetour(int mX, int mY) {
    return (dist(mX, mY, 50, 50) < 25);
  }

  // Change le thème et réinitialise les sélections suivantes
  void selectionnerPaysParNom(String theme) {
    if (theme.equals("PAYS")) indexThematiqueSelectionnee = 0;
    else if (theme.equals("GEOGRAPHIE")) indexThematiqueSelectionnee = 1;
    else if (theme.equals("LIBRE")) indexThematiqueSelectionnee = 2;

    mettreAJourPays(theme);
    indexPaysSelectionne = -1;
    indexSousThemeSelectionne = -1;
    indexDifficulteSelectionnee = -1;
  }

  // Définit la liste des sujets selon la thématique choisie
  void mettreAJourPays(String thematique) {
    if (thematique.equals("PAYS")) {
      listePays = new String[] {"La France", "L'Allemagne", "La Turquie"};
    } else if (thematique.equals("GEOGRAPHIE")) {
      listePays = new String[] {"PAYS"};
    } else if (thematique.equals("LIBRE")) {
      listePays = new String[] {"Animaux", "Sports", "Nature"};
    } else {
      listePays = new String[] {};
    }
  }

  // Définit les sous-catégories selon le pays ou sujet
  void mettreAJourSousThemes(String thematique, String pays) {
    if (thematique.equals("PAYS")) {
      listeSousThemes = new String[] {"GASTRONOMIE", "MARQUES", "HISTOIRE"};
    } else if (thematique.equals("GEOGRAPHIE")) {
      listeSousThemes = new String[] {"HYMNE", "DRAPEAU", "PAYSAGE"};
    } else if (thematique.equals("LIBRE")) {
      if (pays.equals("Animaux")) listeSousThemes = new String[] {"SAUVAGES", "DOMESTIQUES"};
      else if (pays.equals("Sports")) listeSousThemes = new String[] {"COLLECTIFS", "INDIVIDUELS"};
      else listeSousThemes = new String[] {"PLANTES"};
    } else {
      listeSousThemes = new String[] {};
    }
  }

  // Active le signal de lancement de partie
  void lancerJeu() {
    lancementJeuDemande = true;
  }

  String getThematiqueChoisie() {
    return listeThematiques[indexThematiqueSelectionnee];
  }
  String getPaysChoisi() {
    return listePays[indexPaysSelectionne];
  }
  String getSousThemeChoisi() {
    return listeSousThemes[indexSousThemeSelectionne];
  }

  // Retourne le nombre total de cartes selon la difficulté
  int getNbCartesChoisi() {
    if (indexDifficulteSelectionnee == 1) return 24;
    if (indexDifficulteSelectionnee == 2) return 36;
    return 16;
  }
}
