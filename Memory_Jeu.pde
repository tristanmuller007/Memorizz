class MemoryJeu {

  PApplet parent;
  Parametres reglages;
  
  Carte[] cartes;
  GestionnaireImages gestImages;

  int nbCartes;
  int nbPaires;
  String thematique;
  String pays;
  String sousTheme;
  
  Carte carte1Selectionnee = null;
  Carte carte2Selectionnee = null;
  int nbPaireTrouvees = 0;
  int nbCoups = 0;

  int tempsPause = 0;
  int tempsPauseMax = 60;

  int lignes, colonnes;
  float margeX, margeY;
  float largeurCarte, hauteurCarte;

  boolean jeuTerminee = false;
  int tempsDebut;
  int tempsEcoule;
  boolean chronometre = true;
  boolean scoreEnregistre = false;
  
  // Support des hymnes
  boolean modeHymne = false;
  
  MemoryJeu(PApplet p, Parametres r, String _thematique, String _pays, String _sousTheme, int _nbCartes) {
    this.parent = p;
    this.reglages = r;
    this.thematique = _thematique;
    this.pays = _pays;
    this.sousTheme = _sousTheme;
    this.nbCartes = _nbCartes;
    this.nbPaires = nbCartes / 2;

    gestImages = new GestionnaireImages(parent);
    gestImages.chargerImageDos();

    // Détection du mode hymne
    modeHymne = (sousTheme.equals("HYMNE"));
    
    if (modeHymne) {
      println("=== MODE HYMNE ACTIVÉ ===");
    }

    calculerGrille();
    creerCartes();
    tempsDebut = millis();
  }

  void calculerGrille() {
    if (nbCartes == 16) {
      lignes = 4;
      colonnes = 4;
    } else if (nbCartes == 24) {
      lignes = 4;
      colonnes = 6;
    } else {
      lignes = 6;
      colonnes = 6;
    }

    margeX = width * 0.05;
    margeY = height * 0.15;

    float espacementX = 20;
    float espacementY = 20;

    largeurCarte = (width - 2 * margeX - (colonnes - 1) * espacementX) / colonnes;
    hauteurCarte = (height - 2 * margeY - (lignes - 1) * espacementY) / lignes;
    if (hauteurCarte > largeurCarte * 1.4) {
      hauteurCarte = largeurCarte * 1.4;
    }
  }

  // Support des hymnes
  void creerCartes() {
    cartes = new Carte[nbCartes];

    PImage[] imageTheme = gestImages.getImages(thematique, pays, sousTheme);
    
    // Récupération des hymnes si mode hymne
    SoundFile[] hymnes = null;
    if (modeHymne) {
      hymnes = gestImages.getHymnes(pays);
      if (hymnes != null) {
        println(" Hymnes récupérés pour association aux cartes");
      } else {
        println(" Aucun hymne disponible");
      }
    }
    
    int[] ids = new int[nbCartes];
    for (int i = 0; i < nbPaires; i++) {
      ids[i * 2] = i;
      ids[i * 2 + 1] = i;
    }

    melangerTableau(ids);

    int index = 0;
    for (int ligne = 0; ligne < lignes; ligne++) {
      for (int col = 0; col < colonnes; col++) {
        if (index < nbCartes) {
          float x = margeX + col * (largeurCarte + 20);
          float y = margeY + ligne * (hauteurCarte + 20);

          cartes[index] = new Carte(ids[index], x, y, largeurCarte, hauteurCarte);
          
          // Association de l'image
          if (ids[index] < imageTheme.length && imageTheme[ids[index]] != null) {
            cartes[index].initCarte(imageTheme[ids[index]]);
          }

          // Association du dos
          cartes[index].initDos(gestImages.imageDos);
          
          // AJOUTÉ : Association de l'hymne si mode hymne
          if (modeHymne && hymnes != null && ids[index] < hymnes.length && hymnes[ids[index]] != null) {
            cartes[index].initSon(hymnes[ids[index]]);
            println(" Carte " + index + " -> Hymne " + ids[index] + " associé");
          }

          index++;
        }
      }
    }
    
    if (modeHymne) {
      println("📊 " + index + " cartes créées avec association hymnes");
    }
  }

  void melangerTableau(int[] tableau) {
    for (int i = tableau.length - 1; i > 0; i--) {
      int j = (int) random(i + 1);
      int temp = tableau[i];
      tableau[i] = tableau[j];
      tableau[j] = temp;
    }
  }

  void afficher() {
    background(reglages.modeSombre ? color(15, 25, 45) : color(240));

    dessinerBandeauInfo();
    for (Carte c: cartes) {
      if (c != null) {
        c.dessinerCarte();
      }
    }

    if (tempsPause > 0) {
      tempsPause--;
      if (tempsPause == 0) {
        verifierPaire();
      }
    }

    if (!jeuTerminee) {
      tempsEcoule = millis() - tempsDebut;
    }
  }

  void dessinerBandeauInfo() {
    fill(0, 180);
    noStroke();
    rect(0, 0, width, 120);
    stroke(0, 210, 255, 100);
    strokeWeight(2);
    line(0, 120, width, 120);

    fill(0, 210, 255);
    textAlign(CENTER);
    textSize(28);
    text("MEMORIZZ - " + thematique, width / 2, 35);
    
    fill(reglages.modeSombre ? 255 : 50, 200);
    textSize(18);
    
    // Indication visuelle du mode hymne
    String sousTitreAffichage = pays + " • " + sousTheme;
    if (modeHymne) {
      sousTitreAffichage += " ";
    }
    text(sousTitreAffichage, width / 2, 65);

    textSize(16);
    fill(reglages.modeSombre ? 255 : 0);
    textAlign(LEFT);
    text("Paires: " + nbPaireTrouvees + "/" + nbPaires, 50, 105);

    textAlign(CENTER);
    text("Coups: " + nbCoups, width / 2, 90);

    textAlign(RIGHT);
    String tempsTexte = formaterTemps(tempsEcoule / 1000);
    text("Temps: " + tempsTexte, width - 50, 105);

    float progression = (float) nbPaireTrouvees / nbPaires;
    fill(0, 210, 255, 50);
    rect(width / 2 - 200, 100, 400, 10, 5);
    fill(0, 210, 255);
    rect(width / 2 - 200, 100, 400 * progression, 10, 5);
  }

  String formaterTemps(int secondes) {
    int minutes = secondes / 60;
    int secs = secondes % 60;
    if (minutes > 0) {
      return minutes + "m " + nf(secs, 2) + "s";
    }
    return secs + "s";
  }

  void gererClic(int mX, int mY) {
    if (tempsPause > 0 || jeuTerminee) return;
    if (carte1Selectionnee != null && carte2Selectionnee != null) return;

    for (Carte c: cartes) {
      if (c != null && c.survoleLaCarte(mX, mY)) {
        if (!c.estRetourne && !c.estTrouvee) {
          c.retourner();
          
          if (c.avecSon) {
            c.jouerSon();
            println(" Lecture hymne pour carte ID: " + c.id);
          }

          if (carte1Selectionnee == null) {
            carte1Selectionnee = c;
          } else if (carte2Selectionnee == null && c != carte1Selectionnee) {
            carte2Selectionnee = c;
            nbCoups++;
            tempsPause = tempsPauseMax;
          }

          break;
        }
      }
    }
  }

  void verifierPaire() {
    if (carte1Selectionnee != null && carte2Selectionnee != null) {
      if (carte1Selectionnee.id == carte2Selectionnee.id) {
        carte1Selectionnee.marquerTrouvee();
        carte2Selectionnee.marquerTrouvee();
        nbPaireTrouvees++;
        
        if (modeHymne) {
          println(" Paire trouvée - Hymne continue");
        }
      } else {
        // Arrête les sons si ce n'est pas une paire
        if (carte1Selectionnee.avecSon) {
          carte1Selectionnee.arreterSon();
        }
        if (carte2Selectionnee.avecSon) {
          carte2Selectionnee.arreterSon();
        }
        
        carte1Selectionnee.retourner();
        carte2Selectionnee.retourner();
        
        if (modeHymne) {
          println(" Mauvaise paire - Hymnes arrêtés");
        }
      }

      carte1Selectionnee = null;
      carte2Selectionnee = null;
    }
  }

  void afficherVictoire() {
    fill(0, 0, 0, 220);
    rect(0, 0, width, height);

    for (int i = 20; i > 0; i--) {
      fill(0, 255, 100, 5);
      ellipse(width / 2, height / 2 - 80, 300 + i * 10, 300 + i * 10);
    }

    fill(0, 255, 100);
    textAlign(CENTER, CENTER);
    textSize(70);
    text(reglages.langueFrancais ? "VICTOIRE !" : "VICTORY!", width / 2, height / 2 - 80);

    textSize(30);
    fill(reglages.modeSombre ? 255 : 0);
    text((reglages.langueFrancais ? "Toutes les paires en " : "All pairs in ") + nbCoups + (reglages.langueFrancais ? " coups !" : " moves!"), width / 2, height / 2);

    textSize(24);
    fill(0, 210, 255);
    text((reglages.langueFrancais ? "Temps: " : "Time: ") + formaterTemps(tempsEcoule / 1000), width / 2, height / 2 + 40);

    int etoiles = 3;
    if (nbCoups > nbPaires * 2) etoiles = 2;
    if (nbCoups > nbPaires * 3) etoiles = 1;

    textSize(60);
    fill(255, 215, 0);
    String affichageEtoiles = "";
    for (int i = 0; i < etoiles; i++) affichageEtoiles += "★";
    text(affichageEtoiles, width / 2, height / 2 + 90);

    textSize(20);
    fill(0, 210, 255);
    text(reglages.langueFrancais ? "Appuyez sur ESPACE pour continuer" : "Press SPACE to continue", width / 2, height / 2 + 150);
  }

  boolean estTerminee() {
    return jeuTerminee;
  }

  int getTempsEnSecondes() {
    return tempsEcoule / 1000;
  }

  int getCoups() {
    return nbCoups;
  }
  
  String getDifficulte() {
    if (nbCartes == 16) return "FACILE (16)";
    if (nbCartes == 24) return "MOYEN (24)";
    return "EXPERT (36)";
  }
  
  boolean isScoreEnregistre() {
    return scoreEnregistre;
  }
  
  void marquerScoreEnregistre() {
    scoreEnregistre = true;
  }
  
  void arreterTousLesSons(){
    if(cartes != null){
      for(Carte c : cartes){
        if( c!=null && c.avecSon){
          c.arreterSon();
        }
      }
    }
    println("Tous les hymnes arrêtés");
  }  
}
