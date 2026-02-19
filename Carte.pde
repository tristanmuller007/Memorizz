class Carte {

  int id;                     // Identifiant unique de la carte
  float x, y;                 // Position (coin haut-gauche)
  PImage imageFace;           // Image affichée quand retournée
  PImage imageDos;            // Image affichée face cachée
  SoundFile hymne;            // Fichier audio associé (si thématique géo)
  float largeur, hauteur;     // Dimensions physiques
  boolean estRetourne;        // État : visible ou non
  boolean estTrouvee;         // État : paire déjà validée
  boolean avecSon = false;    // Indique si la carte possède un audio
  final int NBCARTES[] = {16, 24, 36}; // Configurations possibles de grille

  float angleRetournement = 0;       // Angle actuel pour l'effet 3D
  boolean enAnimationRetournement = false; // Verrou d'animation

  color couleurBordure = color(0, 210, 255);
  color couleurDos = color(20, 30, 50);

  //Crée une nouvelle instance de carte avec ses dimensions de base

  Carte(int _id, float _x, float _y, float _largeur, float _hauteur) {
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.largeur = _largeur;
    this.hauteur = _hauteur;
    this.estRetourne = false;
    this.estTrouvee = false;
  }

  void initCarte(PImage img) {
    this.imageFace = img;
  }

  void initDos(PImage img) {
    this.imageDos = img;
  }

  void initSon(SoundFile son) {
    this.hymne = son;
    this.avecSon = true;
  }

  void jouerSon() {
    if (avecSon && hymne != null) {
      hymne.play();
    }
  }

  void arreterSon() {
    if (avecSon && hymne != null) {
      hymne.stop();
    }
  }

  // Gère le rendu visuel de la carte incluant l'animation de rotation

  void dessinerCarte() {
    pushMatrix();
    // On se place au centre de la carte pour la rotation
    translate(x + largeur / 2, y + hauteur / 2);

    // Calcul de l'animation de retournement
    if (enAnimationRetournement) {
      angleRetournement += 15;
      if (angleRetournement >= 180) {
        angleRetournement = 180;
        enAnimationRetournement = false;
        estRetourne = !estRetourne;
      }
    }

    // Effet de miroir progressif pour simuler la 3D
    float scaleX = cos(radians(angleRetournement));
    scale(abs(scaleX), 1);

    // Style de bordure selon l'état
    if (!estTrouvee) {
      stroke(couleurBordure, 100);
      strokeWeight(3);
    } else {
      stroke(0, 255, 100, 150);
      strokeWeight(4);
    }

    // Fond de la carte
    fill(estTrouvee ? color(0, 100, 50, 200) : 255);
    rect(-largeur / 2, -hauteur / 2, largeur, hauteur, 8);

    // === RENDU DU CONTENU ===
    if (estRetourne || estTrouvee) {
      // Affichage de la face avant
      if (imageFace != null) {
        imageMode(CENTER);
        image(imageFace, 0, 0, largeur * 0.9, hauteur * 0.9);

        // Indicateur visuel de présence sonore (icône note de musique simplifiée)
        if (avecSon) {
          fill(255, 200);
          stroke(0, 150);
          strokeWeight(2);
          ellipse(largeur / 2 - 25, -hauteur / 2 + 25, 20, 20);
          line(largeur / 2 - 15, -hauteur / 2 + 25, largeur / 2 - 15, -hauteur / 2 + 10);
        }
      } else {
        // Fallback textuel si image manquante
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(32);
        text(id, 0, 0);
      }
    } else {
      // Affichage du dos de la carte
      if (imageDos != null) {
        imageMode(CENTER);
        image(imageDos, 0, 0, largeur * 0.9, hauteur * 0.9);
      } else {
        // Fallback graphique si image de dos manquante
        fill(couleurDos);
        rect(-largeur / 2 + 10, -hauteur / 2 + 10, largeur - 20, hauteur - 20, 6);

        stroke(couleurBordure, 50);
        strokeWeight(2);
        line(-largeur / 4, -hauteur / 4, largeur / 4, hauteur / 4);
        line(largeur / 4, -hauteur / 4, -largeur / 4, hauteur / 4);
      }
    }
    popMatrix();
  }

  // Vérifie si la souris se trouve au-dessus de la carte
  boolean survoleLaCarte(int mX, int mY) {
    return (mX > x && mX < x + largeur && mY > y && mY < y + hauteur);
  }

  //Déclenche l'animation de retournement fluide
  void retourner() {
    if (!estTrouvee && !enAnimationRetournement) {
      enAnimationRetournement = true;
      angleRetournement = 0;
    }
  }

  //Change l'état sans animation (usage technique)
  void retournerInstant() {
    estRetourne = !estRetourne;
  }

  //Valide la carte lorsqu'une paire est formée
  void marquerTrouvee() {
    this.estTrouvee = true;
    this.estRetourne = true;
  }

  // Remet la carte dans son état initial (pour nouvelle partie)
  void Reinitialiser() {
    this.estTrouvee = false;
    this.estRetourne = false;
    this.angleRetournement = 0;
    this.enAnimationRetournement = false;
  }
}
