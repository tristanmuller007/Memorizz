class Leaderboard {
   
  // Référence aux paramètres globaux (mode sombre, etc.)
  Parametres reglages;

  color couleurAccent = color(0, 210, 255);
  color couleurFondSombre = color(8, 12, 28);
  color couleurFondClair = color(240);
  
  // Système de particules pour l'arrière-plan animé
  float[] particuleX = new float[40];
  float[] particuleY = new float[40];
  float[] particuleTaille = new float[40];
  float[] particuleAlpha = new float[40];
  float[] particuleVitesse = new float[40];
  
  // Liste des scores et configuration d'affichage
  ArrayList<ScoreEntry> listeScores;
  int affichageMax = 10;
  
  // Gestion de l'interface de saisie du nom
  boolean saisieNomActive = false;
  String nomJoueur = "";
  int maxCaracteres = 15;
  
  // Stockage des données du dernier score réalisé
  int dernierTemps = 0;
  int dernierCoups = 0;
  String dernierTheme = "";
  String dernierPays = "";
  String dernierDifficulte = "";
  
  // Variables d'animation pour les lignes du tableau
  float[] ligneOffset = new float[10];
  float[] ligneAlpha = new float[10];
  
  // Initialise les réglages, les particules et charge les scores sauvegardés
  Leaderboard(Parametres r) {
    this.reglages = r;
    listeScores = new ArrayList<ScoreEntry>();

    for (int i = 0; i < 40; i++) {
      particuleX[i] = random(width);
      particuleY[i] = random(height);
      particuleTaille[i] = random(3, 15);
      particuleAlpha[i] = random(5, 20);
      particuleVitesse[i] = random(0.2, 0.6);
    }

    for (int i = 0; i < 10; i++) {
      ligneOffset[i] = 0;
      ligneAlpha[i] = 0;
    }

    chargerScores();
  }
  
  // Gère le rendu global de l'écran de classement
  void afficher(boolean anglais) {
    dessinerArrierePlan();

    pushMatrix();
    translate(0, 0, 1);

    fill(0, 210, 255, 30);
    textAlign(CENTER, TOP);
    textSize(48);
    for (int i = 8; i > 0; i -= 2) {
      fill(0, 210, 255, 15 - i);
      text(anglais ? "LEADERBOARD" : "CLASSEMENT", width / 2 + i/2, 55 + i/2);
    }
    
    fill(reglages.modeSombre ? 255 : 0);
    textSize(48);
    text(anglais ? "LEADERBOARD" : "CLASSEMENT", width / 2, 55);

    fill(couleurAccent, 120);
    textSize(16);
    text(anglais ? "Hall of Fame" : "Tableau d'Honneur", width / 2, 110);

    popMatrix();

    if (saisieNomActive) {
      afficherSaisieNom(anglais);
    } else {
      afficherTableauScores(anglais);
    }

    dessinerBoutonRetour(anglais);
  }
  
  // Dessine le dégradé de fond et anime les particules montantes
  void dessinerArrierePlan() {
    noStroke();
    if (reglages.modeSombre) {
      for (int i = 0; i <= height; i += 2) {
        float inter = map(i, 0, height, 0, 1);
        color c = lerpColor(color(8, 12, 28), color(12, 18, 38), inter);
        stroke(c);
        strokeWeight(2);
        line(0, i, width, i);
      }
    } else {
      background(240);
    }

    noStroke();
    for (int i = 0; i < 40; i++) {
      for (int j = 3; j > 0; j--) {
        fill(couleurAccent, particuleAlpha[i] / (j + 1));
        ellipse(particuleX[i], particuleY[i], particuleTaille[i] + j * 4, particuleTaille[i] + j * 4);
      }

      fill(couleurAccent, particuleAlpha[i]);
      ellipse(particuleX[i], particuleY[i], particuleTaille[i], particuleTaille[i]);

      particuleY[i] -= particuleVitesse[i];
      particuleAlpha[i] = 5 + abs(sin(frameCount * 0.01 + i)) * 15;

      if (particuleY[i] < -50) {
        particuleY[i] = height + 50;
        particuleX[i] = random(width);
      }
    }
  }
  
  // Affiche la fenêtre contextuelle pour entrer son nom après une victoire
  void afficherSaisieNom(boolean anglais) {
    fill(0, 0, 0, 180);
    noStroke();
    rect(0, 0, width, height);

    float panelW = 650;
    float panelH = 450;
    float panelX = width / 2 - panelW / 2;
    float panelY = height / 2 - panelH / 2;

    noStroke();
    for (int i = 30; i > 0; i -= 2) {
      fill(0, 210, 255, 8 - i/5);
      rect(panelX - i, panelY - i, panelW + i * 2, panelH + i * 2, 25 + i/2);
    }

    for (int i = 0; i < panelH; i += 2) {
      float inter = map(i, 0, panelH, 0, 1);
      fill(lerpColor(color(15, 22, 45), color(20, 28, 52), inter), 245);
      noStroke();
      rect(panelX, panelY + i, panelW, 2);
    }

    noFill();
    stroke(couleurAccent, 80);
    strokeWeight(2);
    rect(panelX, panelY, panelW, panelH, 20);

    pushMatrix();
    translate(0, 0, 1);

    pushMatrix();
    translate(width / 2, panelY + 50);
    rotate(frameCount * 0.02);

    for (int i = 5; i > 0; i--) {
      fill(255, 215, 0, 40 - i * 5);
      drawStar(0, 0, 25 + i * 3, 15 + i * 2, 5);
    }
    fill(255, 215, 0);
    drawStar(0, 0, 25, 15, 5);
    popMatrix();

    fill(255);
    textAlign(CENTER, TOP);
    textSize(30);
    text(anglais ? "NEW HIGH SCORE!" : "NOUVEAU RECORD!", width / 2, panelY + 100);

    stroke(couleurAccent, 60);
    strokeWeight(1);
    float lineY = panelY + 145;
    line(width / 2 - 150, lineY, width / 2 + 150, lineY);

    fill(couleurAccent, 200);
    textSize(16);
    textAlign(LEFT);

    float statsX = width / 2 - 180;

    fill(couleurAccent, 100);
    ellipse(statsX, panelY + 175, 8, 8);
    fill(255, 220);
    textSize(18);
    text((anglais ? "Time: " : "Temps: ") + formaterTemps(dernierTemps), statsX + 20, panelY + 170);

    fill(couleurAccent, 100);
    ellipse(statsX, panelY + 210, 8, 8);
    fill(255, 220);
    text((anglais ? "Moves: " : "Coups: ") + dernierCoups, statsX + 20, panelY + 205);

    fill(couleurAccent, 100);
    ellipse(statsX, panelY + 245, 8, 8);
    fill(255, 220);
    text(dernierTheme + " • " + dernierPays, statsX + 20, panelY + 240);

    float inputY = panelY + 295;

    for (int i = 4; i > 0; i--) {
      fill(couleurAccent, 10);
      rect(width / 2 - 210 - i, inputY - i, 420 + i * 2, 60 + i * 2, 12);
    }

    fill(18, 25, 45);
    stroke(couleurAccent, nomJoueur.length() > 0 ? 150 : 80);
    strokeWeight(2);
    rect(width / 2 - 210, inputY, 420, 60, 10);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(22);
    if (frameCount % 60 < 30 && nomJoueur.length() < maxCaracteres) {
      fill(couleurAccent, 150);
      rect(width / 2 + textWidth(nomJoueur) / 2, inputY + 20, 2, 20);
    }

    fill(nomJoueur.length() > 0 ? 255 : color(120, 140, 160));
    text(nomJoueur.length() > 0 ? nomJoueur : (anglais ? "Enter your name..." : "Entrez votre nom..."),
      width / 2, inputY + 30);

    fill(couleurAccent, 100);
    textSize(12);
    text(nomJoueur.length() + "/" + maxCaracteres, width / 2 + 180, inputY + 70);

    float btnY = panelY + 385;
    boolean survol = mouseX > width / 2 - 120 && mouseX < width / 2 + 120 &&
      mouseY > btnY - 28 && mouseY < btnY + 28;

    if (nomJoueur.length() > 0) {
      for (int i = 8; i > 0; i--) {
        fill(couleurAccent, survol ? 20 : 10);
        rect(width / 2 - 120 - i, btnY - 28 - i, 240 + i * 2, 56 + i * 2, 15);
      }
    }

    if (nomJoueur.length() > 0) {
      if (survol) {
        fill(couleurAccent);
      } else {
        fill(lerpColor(color(18, 25, 45), couleurAccent, 0.3));
      }
      stroke(couleurAccent, survol ? 255 : 150);
    } else {
      fill(40, 50, 70);
      stroke(60, 70, 90);
    }
    strokeWeight(2);
    rect(width / 2 - 120, btnY - 28, 240, 56, 12);

    fill(nomJoueur.length() > 0 ? (survol ? 0 : 255) : color(100, 110, 120));
    textSize(20);
    text(anglais ? "SUBMIT" : "VALIDER", width / 2, btnY);

    fill(couleurAccent, 80);
    textSize(13);
    text(anglais ? "Press ENTER to submit • ESC to skip" : "ENTRÉE pour valider • ÉCHAP pour passer",
      width / 2, panelY + panelH - 25);

    popMatrix();
  }
  
  // Gère le dessin de la liste des scores avec effets de survol
  void afficherTableauScores(boolean anglais) {
    float tableauY = 170;
    float ligneH = 65;
    float margeX = width * 0.12;
    float tableauW = width - 2 * margeX;

    for (int i = 10; i > 0; i--) {
      fill(0, 210, 255, 5);
      rect(margeX - i, tableauY - i, tableauW + i * 2, (ligneH * (min(listeScores.size(), affichageMax) + 1)) + 20 + i * 2, 15);
    }

    pushMatrix();
    translate(0, 0, 1);

    for (int i = 0; i < ligneH; i += 2) {
      float inter = map(i, 0, ligneH, 0, 1);
      fill(lerpColor(color(0, 210, 255, 25), color(0, 210, 255, 15), inter));
      noStroke();
      rect(margeX, tableauY + i, tableauW, 2, 12);
    }

    noFill();
    stroke(couleurAccent, 60);
    strokeWeight(1);
    rect(margeX, tableauY, tableauW, ligneH, 12, 12, 0, 0);
    
    fill(reglages.modeSombre ? 255 : 0, 240);
    textAlign(LEFT, CENTER);
    textSize(15);
    text(anglais ? "RANK" : "RANG", margeX + 50, tableauY + ligneH / 2);
    text(anglais ? "PLAYER" : "JOUEUR", margeX + 170, tableauY + ligneH / 2);

    textAlign(CENTER, CENTER);
    text(anglais ? "TIME" : "TEMPS", margeX + 430, tableauY + ligneH / 2);
    text(anglais ? "MOVES" : "COUPS", margeX + 580, tableauY + ligneH / 2);

    textAlign(LEFT, CENTER);
    text(anglais ? "THEME" : "THÈME", margeX + 720, tableauY + ligneH / 2);

    popMatrix();

    int nbAffiche = min(listeScores.size(), affichageMax);

    for (int i = 0; i < nbAffiche; i++) {
      ScoreEntry score = listeScores.get(i);
      float y = tableauY + ligneH + (i * ligneH) + 10;

      boolean survol = mouseY > y && mouseY < y + ligneH - 10 &&
        mouseX > margeX && mouseX < margeX + tableauW;

      if (survol) {
        ligneOffset[i] = lerp(ligneOffset[i], 8, 0.2);
        ligneAlpha[i] = lerp(ligneAlpha[i], 255, 0.2);
      } else {
        ligneOffset[i] = lerp(ligneOffset[i], 0, 0.15);
        ligneAlpha[i] = lerp(ligneAlpha[i], 0, 0.15);
      }

      pushMatrix();
      translate(ligneOffset[i], 0);

      if (ligneAlpha[i] > 5) {
        for (int j = 6; j > 0; j--) {
          fill(couleurAccent, ligneAlpha[i] / (j + 2));
          rect(margeX - j, y - j, tableauW + j * 2, ligneH - 10 + j * 2, 8);
        }
      }

      if (i % 2 == 0) {
        fill(18, 25, 42, survol ? 220 : 140);
      } else {
        fill(15, 20, 38, survol ? 220 : 120);
      }

      noStroke();
      rect(margeX, y, tableauW, ligneH - 10, 8);

      if (survol) {
        noFill();
        stroke(couleurAccent, 120);
        strokeWeight(1.5);
        rect(margeX, y, tableauW, ligneH - 10, 8);
      }

      pushMatrix();
      translate(0, 0, 1);

      if (i < 3) {
        color medalColor = i == 0 ? color(255, 215, 0) : i == 1 ? color(192, 192, 192) : color(205, 127, 50);

        for (int j = 3; j > 0; j--) {
          fill(medalColor, 30);
          textSize(26 + j * 2);
          text("", margeX + 35, y + (ligneH - 10) / 2);
        }

        fill(medalColor);
        textSize(26);
        text("", margeX + 35, y + (ligneH - 10) / 2);
      }

      fill(survol ? couleurAccent : color(160, 180, 200));
      textAlign(CENTER, CENTER);
      textSize(survol ? 20 : 18);
      text(i + 1, margeX + 70, y + (ligneH - 10) / 2);

      textAlign(LEFT, CENTER);
      fill(survol ? 255 : color(220, 230, 240));
      textSize(survol ? 19 : 17);
      text(score.nom, margeX + 170, y + (ligneH - 10) / 2);

      textAlign(CENTER, CENTER);
      fill(survol ? couleurAccent : color(160, 200, 220));
      textSize(survol ? 17 : 15);
      text(formaterTemps(score.temps), margeX + 430, y + (ligneH - 10) / 2);

      text(score.coups + "", margeX + 580, y + (ligneH - 10) / 2);

      textAlign(LEFT, CENTER);
      fill(survol ? color(180, 200, 220) : color(140, 160, 180));
      textSize(13);
      String themeAffiche = score.theme + " • " + score.difficulte;
      if (anglais) {
        themeAffiche = traduireTheme(themeAffiche, anglais);
      }
      text(themeAffiche, margeX + 720, y + (ligneH - 10) / 2);

      popMatrix();
      popMatrix();
    }

    if (listeScores.size() == 0) {
      pushMatrix();
      translate(0, 0, 1);

      noFill();
      stroke(couleurAccent, 60);
      strokeWeight(2);
      ellipse(width / 2, height / 2 - 40, 80, 80);

      fill(couleurAccent, 80);
      textAlign(CENTER, CENTER);
      textSize(26);
      text(anglais ? "No scores yet" : "Aucun score enregistré", width / 2, height / 2 + 30);

      fill(couleurAccent, 60);
      textSize(16);
      text(anglais ? "Be the first to play!" : "Soyez le premier à jouer!", width / 2, height / 2 + 65);

      popMatrix();
    }
  }
  
  // Dessine le bouton interactif pour quitter l'écran de classement
  void dessinerBoutonRetour(boolean anglais) {
    float x = 80, y = 80;
    boolean survol = dist(mouseX, mouseY, x, y) < 35;

    pushMatrix();
    translate(x, y);

    if (survol) {
      for (int i = 5; i > 0; i--) {
        fill(couleurAccent, 15);
        ellipse(0, 0, 70 + i * 6, 70 + i * 6);
      }
      scale(1.08);
    }

    fill(18, 25, 45, 200);
    stroke(couleurAccent, survol ? 200 : 120);
    strokeWeight(2);
    ellipse(0, 0, 60, 60);

    stroke(survol ? 255 : couleurAccent);
    strokeWeight(2.5);
    line(10, 0, -10, 0);
    line(-10, 0, -5, -6);
    line(-10, 0, -5, 6);

    popMatrix();

    if (survol) {
      pushMatrix();
      translate(0, 0, 1);
      fill(couleurAccent, 180);
      textAlign(LEFT, CENTER);
      textSize(14);
      text(anglais ? "Back" : "Retour", x + 45, y);
      popMatrix();
    }
  }
  
  // Dessine une forme d'étoile (utilisée pour le feedback visuel)
  void drawStar(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = -PI/2; a < TWO_PI - PI/2; a += angle) {
      float sx = x + cos(a) * radius1;
      float sy = y + sin(a) * radius1;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * radius2;
      sy = y + sin(a + halfAngle) * radius2;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  
  // Gère les clics de souris sur les boutons de l'interface
  void gererClic(int mx, int my) {
    if (saisieNomActive) {
      float panelY = height / 2 - 225;
      if (mx > width / 2 - 120 && mx < width / 2 + 120 &&
        my > panelY + 385 - 28 && my < panelY + 385 + 28 && nomJoueur.length() > 0) {
        validerNom();
      }
    }
  }
  
  // Vérifie si l'utilisateur a cliqué sur le bouton retour
  boolean clicRetour(int mx, int my) {
    return dist(mx, my, 80, 80) < 35;
  }
  
  // Gère la capture des touches clavier pour le nom du joueur
  void ecrireNom(char c) {
    if (!saisieNomActive) return;

    if (c == BACKSPACE && nomJoueur.length() > 0) {
      nomJoueur = nomJoueur.substring(0, nomJoueur.length() - 1);
    } else if (c == ENTER || c == RETURN) {
      if (nomJoueur.length() > 0) {
        validerNom();
      }
    } else if (c >= 32 && c <= 126 && nomJoueur.length() < maxCaracteres) {
      nomJoueur += c;
    }
  }
  
  // Enregistre les statistiques de fin de partie et active la saisie si besoin
  void ajouterScore(String nom, int temps, int coups, String theme, String pays, String difficulte) {
    dernierTemps = temps;
    dernierCoups = coups;
    dernierTheme = theme;
    dernierPays = pays;
    dernierDifficulte = difficulte;

    if (nom.equals("")) {
      saisieNomActive = true;
      nomJoueur = "";
    } else {
      ScoreEntry nouveau = new ScoreEntry(nom, temps, coups, theme, pays, difficulte);
      listeScores.add(nouveau);
      trierScores();
      sauvegarderScores();
    }
  }
  
  // Valide le nom saisi et finalise l'ajout du score
  void validerNom() {
    if (nomJoueur.length() > 0) {
      ScoreEntry nouveau = new ScoreEntry(nomJoueur, dernierTemps, dernierCoups, dernierTheme, dernierPays, dernierDifficulte);
      listeScores.add(nouveau);
      trierScores();
      sauvegarderScores();

      saisieNomActive = false;
      nomJoueur = "";
    }
  }
  
  // Trie la liste des scores par temps puis par nombre de coups
  void trierScores() {
    listeScores.sort((a, b) -> {
      if (a.temps != b.temps) {
        return a.temps - b.temps;
      }
      return a.coups - b.coups;
    }
    );
  }
  
  // Charge les scores depuis le fichier texte local
  void chargerScores() {
    String[] lignes = loadStrings("scores.txt");
    if (lignes != null) {
      for (String ligne : lignes) {
        String[] parts = split(ligne, '|');
        if (parts.length >= 6) {
          try {
            String nom = parts[0];
            int temps = int(parts[1]);
            int coups = int(parts[2]);
            String theme = parts[3];
            String pays = parts[4];
            String difficulte = parts[5];
            listeScores.add(new ScoreEntry(nom, temps, coups, theme, pays, difficulte));
          }
          catch (Exception e) {
            println("Erreur lecture score: " + ligne);
          }
        }
      }
    }
    trierScores();
  }
  
  // Sauvegarde la liste complète des scores dans un fichier texte
  void sauvegarderScores() {
    String[] lignes = new String[listeScores.size()];
    for (int i = 0; i < listeScores.size(); i++) {
      ScoreEntry s = listeScores.get(i);
      lignes[i] = s.nom + "|" + s.temps + "|" + s.coups + "|" +
        s.theme + "|" + s.pays + "|" + s.difficulte;
    }
    saveStrings("data/scores.txt", lignes);
  }
  
  // Convertit un nombre de secondes en format lisible (ex: 1m 05s)
  String formaterTemps(int secondes) {
    int minutes = secondes / 60;
    int secs = secondes % 60;
    if (minutes > 0) {
      return minutes + "m " + nf(secs, 2) + "s";
    }
    return secs + "s";
  }
  
  // Traduit les étiquettes de thèmes et difficultés si la langue est réglée sur anglais
  String traduireTheme(String texte, boolean anglais) {
    if (!anglais) return texte;

    texte = texte.replace("PAYS", "COUNTRIES");
    texte = texte.replace("GEOGRAPHIE", "GEOGRAPHY");
    texte = texte.replace("LIBRE", "FREE");
    texte = texte.replace("FACILE", "EASY");
    texte = texte.replace("MOYEN", "MEDIUM");
    texte = texte.replace("EXPERT", "EXPERT");

    return texte;
  }
}

// Structure simple pour stocker les informations d'un score unique
class ScoreEntry {
  String nom;
  int temps;
  int coups;
  String theme;
  String pays;
  String difficulte;

  ScoreEntry(String n, int t, int c, String th, String p, String d) {
    this.nom = n;
    this.temps = t;
    this.coups = c;
    this.theme = th;
    this.pays = p;
    this.difficulte = d;
  }
}
