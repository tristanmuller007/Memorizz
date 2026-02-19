class Chargement {

  // Nombre de points dans le cercle de chargement rotatif
  int numSegments = 12;

  // État du chargement (passera à true après le délai imparti)
  boolean chargementTermine = false;

  // Positions (x, y) et tailles des 40 particules du fond
  float[] px = new float[40];
  float[] py = new float[40];
  float[] ps = new float[40];

  // Initialise les positions aléatoires des particules de fond
  Chargement() {
    for (int i = 0; i < 40; i++) {
      px[i] = random(width);
      py[i] = random(height);
      ps[i] = random(5, 20);
    }
  }

  //Gère le mouvement ascendant des carrés en arrière-plan
  void dessinerFondAnime() {
    for (int i = 0; i < 40; i++) {
      fill(0, 210, 255, 20); // Couleur cyan très transparente
      noStroke();
      rect(px[i], py[i], ps[i], ps[i]);

      // Déplacement vers le haut
      py[i] -= 0.8;

      // Réinitialisation si la particule sort de l'écran
      if (py[i] < -20) {
        py[i] = height + 20;
        px[i] = random(width);
      }
    }
  }

  // Affiche le titre "MEMORY" avec un effet de lueur (glow)
  void dessinerTitre() {
    dessinerFondAnime();
    textAlign(CENTER, CENTER);

    // Dessine plusieurs couches de texte pour l'effet de halo
    for (int i = 4; i > 0; i--) {
      fill(0, 210, 255, 10 + i * 4);
      textSize(60 + i * 2);
      text("MEMORIZZ", width / 2, height / 3);
    }

    // Texte principal blanc
    fill(255);
    textSize(60);
    text("MEMORIZZ", width / 2, height / 3);
  }

  // Gère l'affichage de la barre de progression et du spinner rotatif
  void dessinerChargement() {
    // Durée totale du chargement en millisecondes
    int duree = 10000;
    int t = millis();

    // Vérifie si le temps est écoulé
    if (t > duree) {
      chargementTermine = true;
      return;
    }

    // Calcul de la longueur de la barre et du pourcentage (0-100)
    float l = map(t, 0, duree, 0, width * 0.6);
    int p = int(map(t, 0, duree, 0, 100));
    if (p > 100) p = 100;

    float y = height - 100;
    float x = width * 0.2;

    // Fond de la barre de progression
    fill(30, 40, 60);
    rect(x, y, width * 0.6, 8, 10);

    // Effet de lueur (glow) autour de la barre de progression
    noStroke();
    for (int i = 5; i > 0; i--) {
      fill(0, 210, 255, 15);
      rect(x - i, y - i, min(l + i * 2, width * 0.6 + i * 2), 8 + i * 2, 10);
    }

    // Remplissage de la barre de progression
    fill(0, 210, 255);
    rect(x, y, l, 8, 10);

    // Affichage du texte de pourcentage
    fill(0, 210, 255);
    textSize(16);
    textAlign(RIGHT, BOTTOM);
    text(p + "%", x + width * 0.6, y - 10);

    // --- CERCLE DE CHARGEMENT ROTATIF (SPINNER) ---
    pushMatrix();
    translate(width / 2, height - 180);

    // Détermine quel segment est le plus lumineux en fonction du temps
    int head = (frameCount / 5) % numSegments;

    for (int i = 0; i < numSegments; i++) {
      pushMatrix();
      rotate(radians(map(i, 0, numSegments, 0, 360)));

      // Calcul de la traînée lumineuse
      int dist = (head - i + numSegments) % numSegments;
      fill(0, 210, 255, map(dist, 0, numSegments - 1, 255, 0));
      float taille = map(dist, 0, numSegments - 1, 10, 2);

      ellipse(30, 0, taille, taille);
      popMatrix();
    }
    popMatrix();
  }
}
