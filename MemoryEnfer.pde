class MemoryEnfer {

  PApplet parent;
  Parametres reglages;
  Carte[] cartes;
  GestionnaireImages gestImages;

  int nbCartes = 64;
  int nbPaires = 32;

  Carte carte1Selectionnee = null;
  Carte carte2Selectionnee = null;
  int nbPaireTrouvees = 0;
  int nbCoups = 0;

  int tempsPause = 0;
  int tempsPauseMax = 60;
  int lignes = 8, colonnes = 8;
  float margeX, margeY, largeurCarte, hauteurCarte;

  boolean jeuTerminee = false;
  int intervalMelange = 5000; // Par défaut
  int prochainMelange;
  
  boolean enCourseDeMelange = false;
  int dureeMelange = 60;
  int compteurMelange = 0;

  MemoryEnfer(PApplet p, Parametres r) {
    this.parent = p;
    this.reglages = r;
    gestImages = new GestionnaireImages(parent);
    gestImages.chargerImageDos();
    calculerGrille();
    creerCartes();
    prochainMelange = millis() + intervalMelange;
  }

  // === FONCTION AJOUTÉE POUR GÉRER LES NIVEAUX ===
  void reinitialiserPourNiveau(int niveau) {
    println(" CHARGEMENT DU NIVEAU " + niveau + " ");
    
    // 1. Reset
    nbPaireTrouvees = 0;
    nbCoups = 0;
    jeuTerminee = false;
    tempsPause = 0;
    if (carte1Selectionnee != null) carte1Selectionnee.arreterSon();
    if (carte2Selectionnee != null) carte2Selectionnee.arreterSon();
    carte1Selectionnee = null;
    carte2Selectionnee = null;
    
    // 2. Difficulté
    if (niveau == 1) {
      intervalMelange = 5000; // 5 secondes
      dureeMelange = 60;
    } else if (niveau == 2) {
      intervalMelange = 3000; // 3 secondes (Plus dur !)
      dureeMelange = 90;
    }
    
    // 3. Remélanger
    int[] ids = new int[nbCartes];
    for (int i = 0; i < nbPaires; i++) { ids[i*2] = i; ids[i*2+1] = i; }
    melangerTableau(ids);
    
    // 4. Reset Cartes
    for (int i = 0; i < nbCartes; i++) {
      if (cartes[i] != null) {
        cartes[i].id = ids[i];
        cartes[i].estTrouvee = false;
        cartes[i].estRetourne = false;
        cartes[i].angleRetournement = 0;
        cartes[i].initCarte(creerImageEnfer(ids[i])); // Regen image
      }
    }
    
    prochainMelange = millis() + intervalMelange;
    enCourseDeMelange = false;
  }

  void calculerGrille() {
    margeX = width * 0.02; margeY = height * 0.15;
    float espacementX = 15; float espacementY = 15;
    largeurCarte = (width - 2*margeX - (colonnes-1)*espacementX) / colonnes;
    hauteurCarte = (height - 2*margeY - (lignes-1)*espacementY) / lignes;
    if (hauteurCarte > largeurCarte * 1.4) hauteurCarte = largeurCarte * 1.4;
  }

  void creerCartes() {
    cartes = new Carte[nbCartes];
    int[] ids = new int[nbCartes];
    for (int i = 0; i < nbPaires; i++) { ids[i*2] = i; ids[i*2+1] = i; }
    melangerTableau(ids);

    int index = 0;
    for (int ligne = 0; ligne < lignes; ligne++) {
      for (int col = 0; col < colonnes; col++) {
        if (index < nbCartes) {
          float x = margeX + col * (largeurCarte + 15);
          float y = margeY + ligne * (hauteurCarte + 15);
          cartes[index] = new Carte(ids[index], x, y, largeurCarte, hauteurCarte);
          cartes[index].initCarte(creerImageEnfer(ids[index]));
          cartes[index].initDos(gestImages.imageDos);
          cartes[index].couleurBordure = color(255, 0, 0);
          cartes[index].couleurDos = color(80, 0, 0);
          index++;
        }
      }
    }
  }

  PImage creerImageEnfer(int index) {
    PGraphics pg = createGraphics(200, 150);
    pg.beginDraw();
    pg.background(60, 0, 0);
    pg.stroke(255, 50, 50); pg.strokeWeight(3); pg.noFill();
    pg.rect(5, 5, 190, 140, 10);
    pg.fill(255, 100, 100); pg.textAlign(CENTER, CENTER); pg.textSize(16);
    pg.text("ENFER", 100, 30);
    pg.textSize(50); pg.fill(255, 150, 150);
    pg.text(index + 1, 100, 90);
    pg.noStroke();
    for (int i = 0; i < 5; i++) {
      float x = 40 + i * 30; float y = 120 + random(-5, 5);
      pg.fill(255, 100, 0, 100); pg.ellipse(x, y, 15, 25);
      pg.fill(255, 200, 0, 150); pg.ellipse(x, y + 5, 10, 15);
    }
    pg.endDraw();
    return pg;
  }

  void melangerTableau(int[] tableau) {
    for (int i = tableau.length - 1; i > 0; i--) {
      int j = (int)random(i + 1);
      int temp = tableau[i]; tableau[i] = tableau[j]; tableau[j] = temp;
    }
  }
  
  void melangerCartes() {
    for (Carte c : cartes) {
      if (c != null && !c.estTrouvee) {
        c.estRetourne = false; c.angleRetournement = 0; c.enAnimationRetournement = false;
      }
    }
    if (carte1Selectionnee != null) carte1Selectionnee.arreterSon();
    if (carte2Selectionnee != null) carte2Selectionnee.arreterSon();
    carte1Selectionnee = null; carte2Selectionnee = null;
    
    ArrayList<Integer> nonTrouvees = new ArrayList<Integer>();
    for (Carte c : cartes) if (c != null && !c.estTrouvee) nonTrouvees.add(c.id);
    for (int i = nonTrouvees.size() - 1; i > 0; i--) {
      int j = (int)random(i + 1);
      int temp = nonTrouvees.get(i); nonTrouvees.set(i, nonTrouvees.get(j)); nonTrouvees.set(j, temp);
    }
    int idx = 0;
    for (Carte c : cartes) if (c != null && !c.estTrouvee) c.id = nonTrouvees.get(idx++);
    
    enCourseDeMelange = true;
    compteurMelange = dureeMelange;
    prochainMelange = millis() + intervalMelange;
  }

  void terminerAutomatiquement() {
    println(" VICTOIRE CHEAT CODE ACTIVÉE ");
    for (Carte c : cartes) if (c != null) c.marquerTrouvee();
    nbPaireTrouvees = nbPaires;
    jeuTerminee = true;
    if (carte1Selectionnee != null) carte1Selectionnee.arreterSon();
    if (carte2Selectionnee != null) carte2Selectionnee.arreterSon();
    carte1Selectionnee = null; carte2Selectionnee = null;
  }

  void afficher() {
    background(reglages.modeSombre ? color(20, 0, 0) : color(240, 200, 200));
    if (enCourseDeMelange) {
      float alpha = map(compteurMelange, dureeMelange, 0, 150, 0);
      fill(255, 0, 0, alpha); rect(0, 0, width, height);
      compteurMelange--;
      if (compteurMelange <= 0) enCourseDeMelange = false;
    }

    dessinerBandeauInfo();
    for (Carte c : cartes) if (c != null) c.dessinerCarte();
    if (tempsPause > 0) {
      tempsPause--;
      if (tempsPause == 0) verifierPaire();
    }
    if (!jeuTerminee && millis() >= prochainMelange) melangerCartes();
  }

  void dessinerBandeauInfo() {
    fill(0, 0, 0, 200); noStroke(); rect(0, 0, width, 140);
    stroke(255, 0, 0, 150); strokeWeight(2); line(0, 140, width, 140);
    fill(255, 50, 50); textAlign(CENTER); textSize(32);
    text(reglages.langueFrancais ? "MODE ENFER" : "HELL MODE", width/2, 35);
    
    int tempsRestant = max(0, prochainMelange - millis());
    float secondes = tempsRestant / 1000.0;
    textAlign(CENTER);
    if (secondes < 1) fill(255, 0, 0); else if (secondes < 2) fill(255, 100, 0); else fill(255, 200, 200);
    textSize(20);
    text((reglages.langueFrancais ? "Mélange dans: " : "Shuffle in: ") + nf(secondes, 1, 1) + "s", width/2, 95);
    
    float progPaires = (float)nbPaireTrouvees / nbPaires;
    float progTimer = 1 - ((float)tempsRestant / intervalMelange);
    noStroke();
    fill(255, 0, 0, 80); rect(width/2 - 200, 115, 400, 10, 5);
    fill(255, 50, 50); rect(width/2 - 200, 115, 400 * progPaires, 10, 5);
    fill(50, 0, 0); rect(width/2 - 200, 128, 400, 6, 3);
    fill(255, 100, 0); rect(width/2 - 200, 128, 400 * progTimer, 6, 3);
  }

  void gererClic(int mX, int mY) {
    if (tempsPause > 0 || jeuTerminee) return;
    if (carte1Selectionnee != null && carte2Selectionnee != null) return;
    for (Carte c : cartes) {
      if (c != null && c.survoleLaCarte(mX, mY)) {
        if (!c.estRetourne && !c.estTrouvee) {
          c.retourner(); c.jouerSon();
          if (carte1Selectionnee == null) carte1Selectionnee = c;
          else if (carte2Selectionnee == null && c != carte1Selectionnee) {
            carte2Selectionnee = c; nbCoups++; tempsPause = tempsPauseMax;
          }
          break;
        }
      }
    }
  }

  void verifierPaire() {
    if (carte1Selectionnee != null && carte2Selectionnee != null) {
      if (carte1Selectionnee.id == carte2Selectionnee.id) {
        carte1Selectionnee.marquerTrouvee(); carte2Selectionnee.marquerTrouvee();
        nbPaireTrouvees++;
        if (nbPaireTrouvees == nbPaires) jeuTerminee = true;
      } else {
        carte1Selectionnee.arreterSon(); carte2Selectionnee.arreterSon();
        carte1Selectionnee.retourner(); carte2Selectionnee.retourner();
      }
      carte1Selectionnee = null; carte2Selectionnee = null;
    }
  }

  void afficherVictoire() {
    fill(0, 0, 0, 230); rect(0, 0, width, height);
    for (int i = 30; i > 0; i--) { fill(255, 100, 0, 8); ellipse(width/2, height/2 - 80, 400 + i*15, 400 + i*15); }
    fill(255, 150, 0); textAlign(CENTER, CENTER); textSize(80);
    text(reglages.langueFrancais ? "NIVEAU RÉUSSI !" : "LEVEL CLEARED!", width/2, height/2 - 100);
    textSize(35); fill(255, 200, 200);
    text(reglages.langueFrancais ? "VOUS AVEZ SURVÉCU..." : "YOU SURVIVED...", width/2, height/2 - 40);
    textSize(22); fill(255, 150, 150);
    text(reglages.langueFrancais ? "Appuyez sur ESPACE pour continuer" : "Press SPACE to continue", width/2, height/2 + 150);
  }

  boolean estTerminee() { 
  return jeuTerminee; }
}
