class PageAccueil {

  // Objets et données globales de la page
  Parametres reglages; // Référence vers les réglages (mode sombre, etc.)

  // Listes des textes pour les thèmes et leurs descriptions
  String[] nomsThemes = {"PAYS", "GEOGRAPHIE", "LIBRE"};

  String[] descriptionsFR = {
    "Découvrez la culture,\nla gastronomie et l'histoire\nde différents pays",
    "Testez vos connaissances\nsur les drapeaux, capitales\net hymnes nationaux",
    "Thèmes variés :\nanimaux, sports,\net nature"
  };

  String[] descriptionsEN = {
    "Discover the culture,\ngastronomy and history\nof different countries",
    "Test your knowledge\nabout flags, capitals\nand national anthems",
    "Various themes:\nanimals, sports,\nand nature"
  };

  // Variables pour l'effet 3D et la taille des cartes
  float[] angles = new float[3]; // Angle de rotation de chaque carte
  boolean[] retournees = new boolean[3]; // État de la carte (face ou dos)
  float cW = 200, cH = 280; // Largeur (Width) et Hauteur (Height) des cartes

  // Variables pour les particules carrées qui flottent en arrière-plan
  float[] px = new float[30]; // Positions X
  float[] py = new float[30]; // Positions Y
  float[] ps = new float[30]; // Tailles (Sizes)

  // Variables pour gérer l'arrivée fluide des cartes au début
  float[] progressionApparition = new float[3]; // État de l'animation (0.0 à 1.0)
  int[] delaiApparition = {0, 150, 300}; // Décalage pour que les cartes arrivent l'une après l'autre
  int tempsDebut; // Moment où la page a été chargée
  boolean animationTerminee = false;

  // Variables pour le petit secret (Easter Egg) caché
  float easterX, easterY;
  float easterSize = 25;
  float easterPulse = 0; // Pour faire "battre" le cercle
  boolean easterTrouvee = false;

  // CONSTRUCTEUR : Initialise la page quand on la crée
  PageAccueil(Parametres r) {
    this.reglages = r;

    // Prépare les 30 particules du fond à des positions aléatoires
    for (int i = 0; i < 30; i++) {
      px[i] = random(width);
      py[i] = random(height);
      ps[i] = random(5, 20);
    }

    // Met les animations à zéro
    for (int i = 0; i < 3; i++) {
      progressionApparition[i] = 0.0;
    }

    tempsDebut = millis(); // Enregistre l'heure de départ
    repositionnerEasterEgg();
  }

  // Change la position du secret aléatoirement sur l'écran
  void repositionnerEasterEgg() {
    easterX = random(100, width - 100);
    easterY = random(200, height - 200);
    easterTrouvee = false;
  }

  // Remet les cartes face avant
  void reinitialiserCartes() {
    for (int i = 0; i < 3; i++) {
      retournees[i] = false;
    }
    repositionnerEasterEgg();
  }

  // Relance l'animation de montée des cartes
  void reinitialiserAnimation() {
    for (int i = 0; i < 3; i++) {
      progressionApparition[i] = 0.0;
    }
    tempsDebut = millis();
    animationTerminee = false;
  }

  // Calcule l'avancement de l'animation de chaque carte
  void mettreAJourAnimation() {
    if (animationTerminee) return;

    int tempsEcoule = millis() - tempsDebut;
    boolean toutesTerminees = true;

    for (int i = 0; i < 3; i++) {
      int tempsCarteActuelle = tempsEcoule - delaiApparition[i];

      // Si le délai est passé, on fait progresser l'apparition
      if (tempsCarteActuelle > 0 && progressionApparition[i] < 1.0) {
        progressionApparition[i] += 0.025;
        progressionApparition[i] = constrain(progressionApparition[i], 0.0, 1.0);
      }

      if (progressionApparition[i] < 1.0) {
        toutesTerminees = false;
      }
    }
    animationTerminee = toutesTerminees;
  }

  // Dessine tout à l'écran
  void afficher(boolean sombre, boolean anglais) {
    mettreAJourAnimation();

    // Couleur du fond selon le mode (Sombre ou Clair)
    background(reglages.modeSombre ? 10 : 240);
    dessinerFond();

    // Dessin du titre principal
    pushMatrix();
    translate(0, 0, 1);
    fill(0, 210, 255);
    textSize(40);
    textAlign(CENTER, TOP);
    text(
      anglais ? "CHOOSE YOUR THEME" : "CHOISISSEZ VOTRE THÉMATIQUE",
      width/2,80);
    popMatrix();

    // Affiche les boutons de navigation
    dessinerBoutonParametres(sombre, anglais);
    dessinerBoutonLeaderboard(sombre, anglais);

    // Calcule la position horizontale des 3 cartes
    float espacement = width / 4.0;

    for (int i = 0; i < 3; i++) {
      String nomAffiche = nomsThemes[i];

      // Traduction des titres des thèmes
      if (anglais) {
        if (nomAffiche.equals("PAYS")) nomAffiche = "COUNTRIES";
        if (nomAffiche.equals("GEOGRAPHIE")) nomAffiche = "GEOGRAPHY";
        if (nomAffiche.equals("LIBRE")) nomAffiche = "FREE";
      }

      float posX = espacement * (i + 1);

      // Dessine la carte et sa description en dessous
      dessinerCarte(posX, height / 2, i, sombre, nomAffiche, anglais);
      dessinerDescription(posX, height / 2 + cH / 2 + 30, i, sombre, anglais);
    }

    dessinerEasterEgg();
    dessinerCopyright(sombre);
  }

  // Dessine le petit point secret avec un effet de pulsation
  void dessinerEasterEgg() {
    if (easterTrouvee) return;

    pushMatrix();
    translate(0, 0, 2);// le petit secret se dessine par-dessus les cartes

    easterPulse += 0.1;
    float pulse = 1 + sin(easterPulse) * 0.3; // Calcule la taille qui varie

    // Vérifie si la souris est sur le secret
    boolean survol = dist(mouseX, mouseY, easterX, easterY) < easterSize;

    // Dessine la lumiere autour
    noStroke();
    for (int i = 8; i > 0; i--) {
      fill(255, 0, 0, survol ? 40 - i*4 : 20 - i*2);
      ellipse(easterX, easterY, (easterSize + i*8) * pulse, (easterSize + i*8) * pulse);
    }

    // Dessine le centre du bouton
    fill(255, survol ? 50 : 0, 0, survol ? 255 : 200);
    stroke(255, 100, 100);
    ellipse(easterX, easterY, easterSize * pulse, easterSize * pulse);

    // Affiche un '?' ou un triangle selon le survol
    fill(255, 200, 200);
    textAlign(CENTER, CENTER);
    textSize(14);
    if (survol) {
      text("?", easterX, easterY - 1);
      cursor(HAND); // Change le curseur de la souris
    } else {
      noStroke();
      fill(255, 150, 0);
      triangle(
        easterX, easterY - 6,
        easterX - 3, easterY + 4,
        easterX + 3, easterY + 4
      );
    }

    popMatrix();
  }

  // Gère le clic sur le secret
  boolean clicSurEasterEgg(int mx, int my) {
    if (easterTrouvee) return false;

    if (dist(mx, my, easterX, easterY) < easterSize) {
      easterTrouvee = true;
      println("EASTER EGG TROUVÉ !");
      return true;
    }
    return false;
  }

  // Dessine l'icône parametre
  void dessinerBoutonParametres(boolean sombre, boolean anglais) {
    float x = width - 70, y = 70, diametre = 60;
    boolean survol = dist(mouseX, mouseY, x, y) < diametre / 2;

    pushMatrix();// (position 0,0) et sauvegarde
    translate(x, y);//devient le centre de ton bouton.
    if (survol) scale(1.1); // Grossit un peu au survol

    noStroke();
    if (sombre) {
      fill(0, 210, 255, survol ? 50 : 20);
      ellipse(0, 0, diametre + 15, diametre + 15);
    } else {
      fill(0, 0, 0, 30);
      ellipse(2, 2, diametre, diametre);
    }

    fill(sombre ? color(0, 210, 255) : color(255));
    stroke(sombre ? 255 : color(0, 100, 200));
    strokeWeight(3);
    ellipse(0, 0, diametre, diametre);

    // Les 3 barres de l'icône réglages
    stroke(sombre ? 0 : color(0, 100, 200));
    strokeWeight(2);
    line(-12, -8, 12, -8);
    line(-12, 0, 12, 0);
    line(-12, 8, 12, 8);

    fill(sombre ? 255 : 40);
    textAlign(CENTER, TOP);
    textSize(12);
    text(anglais ? "SETTINGS" : "RÉGLAGES", 0, diametre / 2 + 8);

    popMatrix();
  }

  // Dessine l'icône du trophée pour le classement
  void dessinerBoutonLeaderboard(boolean sombre, boolean anglais) {
    float x = width - 70, y = 160, diametre = 60;
    boolean survol = dist(mouseX, mouseY, x, y) < diametre / 2;

    pushMatrix();
    translate(x, y);
    if (survol) scale(1.1);

    noStroke();
    if (sombre) {
      fill(0, 210, 255, survol ? 50 : 20);
      ellipse(0, 0, diametre + 15, diametre + 15);
    } else {
      fill(0, 0, 0, 30);
      ellipse(2, 2, diametre, diametre);
    }

    fill(sombre ? color(0, 210, 255) : color(255));
    stroke(sombre ? 255 : color(0, 100, 200));
    strokeWeight(3);
    ellipse(0, 0, diametre, diametre);

    // Dessin complexe à base de lignes pour créer un trophée stylisé
    stroke(sombre ? 0 : color(0, 100, 200));
    strokeWeight(2);
    noFill();
    arc(0, -5, 20, 20, PI, TWO_PI);
    line(-10, -5, -10, 0);
    line(10, -5, 10, 0);
    line(-8, 0, 8, 0);
    line(-6, 0, -6, 5);
    line(6, 0, 6, 5);
    line(-8, 5, 8, 5);
    arc(-12, -8, 8, 12, HALF_PI, PI + HALF_PI);
    arc(12, -8, 8, 12, -HALF_PI, HALF_PI);

    fill(sombre ? 255 : 40);
    textAlign(CENTER, TOP);
    textSize(11);
    text(anglais ? "RANKING" : "CLASSEMENT", 0, diametre / 2 + 8);

    popMatrix();
  }

  // Fonction pour dessiner chaque carte avec son animation 3D
  void dessinerCarte(float x, float y, int id, boolean sombre, String nomAffiche, boolean anglais) {
    pushMatrix();

    // Gestion du mouvement de montée (Ease-out)
    float progression = progressionApparition[id];
    float ease = 1.0 - pow(1.0 - progression, 3);
    float offsetY = (1.0 - ease) * 150; // La carte part du bas
    float opacite = ease * 255; 

    translate(x, y + offsetY);

    // Calcul de la rotation fluide vers l'angle cible
    float cible = retournees[id] ? PI : 0;
    angles[id] = lerp(angles[id], cible, 0.1);

    rotateY(angles[id]); // Applique la rotation sur l'axe vertical (3D)

    rectMode(CENTER);
    stroke(0, 210, 255);
    strokeWeight(3);

    // SI LA CARTE EST FACE AVANT
    if (angles[id] < HALF_PI) {
      fill(sombre ? 10 : 240, opacite);
      rect(0, 0, cW, cH, 15);

      stroke(0, 210, 255, 100);
      noFill();
      rect(0, 0, cW - 20, cH - 20, 10);

      pushMatrix();
      translate(0, 0, 1);

      fill(100, 150, 200, opacite);
      textAlign(CENTER, CENTER);

      String texteTheme = nomsThemes[id];

      // Adaptations de texte pour l'anglais
      if (anglais) {
        if (texteTheme.equals("PAYS")) texteTheme = "COUNTRIES";
        else if (texteTheme.equals("GEOGRAPHIE")) texteTheme = "GEO";
        else if (texteTheme.equals("LIBRE")) texteTheme = "FREE";
      }

      // Configuration de la taille du texte vertical
      float taillePolice = 45;
      float espacementLettre = 35;

      // Ajustements spécifiques selon la longueur des mots
      if (nomsThemes[id].equals("GEOGRAPHIE")) {
        if (!anglais) {
          taillePolice = 32;
          espacementLettre = 24;
        } else {
          taillePolice = 45;
          espacementLettre = 40;
        }
      } else if (nomsThemes[id].equals("LIBRE")) {
        espacementLettre = 40;
      }

      float hauteurTotale = texteTheme.length() * espacementLettre;
      float startY = -hauteurTotale / 2 + espacementLettre / 2;

      // Dessine le titre lettre par lettre verticalement avec une légère rotation aléatoire
      for (int i = 0; i < texteTheme.length(); i++) {
        char lettre = texteTheme.charAt(i);
        textSize(taillePolice);

        pushMatrix();
        translate(0, startY + i * espacementLettre);
        rotate(radians(random(-3, 3))); // Petit effet de "désordre" stylé

        text(lettre, 0, 0);
        popMatrix();
      }

      popMatrix();
    } 
    // SI LA CARTE EST FACE ARRIÈRE (RETOURNEE)
    else {
      pushMatrix();  
      rotateY(PI); // On tourne le contenu pour qu'il ne soit pas à l'envers (miroir)
      
      fill(0, 210, 255, opacite);
      rect(0, 0, cW, cH, 15);

      fill(0, opacite);
      textSize(24);
      textAlign(CENTER, CENTER);
      text(nomAffiche.toUpperCase(), 0, 0);
      
      popMatrix();
    }

    popMatrix();
    rectMode(CORNER);
  }

  // Dessine le texte explicatif sous les cartes
  void dessinerDescription(float x, float y, int id, boolean sombre, boolean anglais) {
    String[] descriptions = anglais ? descriptionsEN : descriptionsFR;
    boolean carteRetournee = (angles[id] > HALF_PI);

    // On affiche la description que si la carte n'est pas retournée
    if (!carteRetournee) {
      pushMatrix();
      translate(0, 0, 1);

      // Détecte si la souris survole la carte correspondante
      float xCarte = x;
      float yCarte = height / 2;
      boolean survol = (mouseX > xCarte - cW / 2 && mouseX < xCarte + cW / 2 &&
        mouseY > yCarte - cH / 2 && mouseY < yCarte + cH / 2);

      // Si survol, on dessine un petit fond lumineux derrière le texte
      if (survol) {
        fill(0, 210, 255, 30);
        noStroke();
        rect(x - 110, y - 10, 220, 70, 10);
        fill(0, 210, 255); 
      } else {
        fill(reglages.modeSombre ? color(100, 150, 200) : color(80, 100, 120));
      }

      textAlign(CENTER, TOP);
      textSize(14);
      textLeading(18); // Espacement entre les lignes de texte
      text(descriptions[id], x, y);

      popMatrix();
    }
  }

  // Vérifie si on a cliqué sur une carte et renvoie le nom du thème
  String detecterChoixPays(int mx, int my) {
    if (!animationTerminee) return "";

    float espacement = width / 4.0;

    for (int i = 0; i < 3; i++) {
      float x = espacement * (i + 1);

      // Vérifie les limites du rectangle de la carte
      if (
        mx > x - cW/2 && mx < x + cW/2 &&
        my > height/2 - cH/2 && my < height/2 + cH/2
      ) {
        retournees[i] = true; // Déclenche la rotation
        return nomsThemes[i]; // Renvoie le thème choisi
      }
    }
    return "";
  }

  // Vérifie si on a cliqué sur le bouton de classement
  boolean clicSurLeaderboard(int mx, int my) {
    return dist(mx, my, width - 70, 160) < 35;
  }

  // Gère l'animation des carrés bleus en fond d'écran
  void dessinerFond() {
    for (int i = 0; i < 30; i++) {
      fill(0, 210, 255, 30);
      noStroke();
      rect(px[i], py[i], ps[i], ps[i]);

      py[i] -= 0.5; // Fait monter les carrés doucement

      // Si le carré sort par le haut, il réapparaît en bas
      if (py[i] < 0) {
        py[i] = height;
      }
    }
  }

  // Affiche le petit texte de copyright en bas
  void dessinerCopyright(boolean sombre) {
    fill(sombre ? 255 : 50, 100);
    textSize(16);
    textAlign(CENTER, BOTTOM);
    text("© Memorizz - 2026", width/2, height - 30);
  }
}
