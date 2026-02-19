/*
 * ========================================
 * CLASSE PARAMETRES
 * ========================================
 * Gère tous les paramètres configurables de l'application :
 * - Mode d'affichage (sombre/clair)
 * - Langue (français/anglais)
 * - Audio (son activé/désactivé et volume)
 * - Accessibilité (police agrandie)
 * ========================================
 */

class Parametres {
  
  // ========================================
  // ÉTATS ET RÉGLAGES UTILISATEUR
  // ========================================
  
  // Mode d'affichage sombre (true) ou clair (false)
  boolean modeSombre = true;
  
  // Langue française (true) ou anglaise (false)
  boolean langueFrancais = true;
  
  // Son activé (true) ou désactivé (false)
  boolean sonActif = true;
  
  // Mode accessibilité avec police agrandie
  boolean modeAccessibilite = false;
  
  // Volume audio fluide de 0.0 (muet) à 1.0 (maximum)
  float volumeSon = 0.66; 
  
  // Couleur d'accentuation principale (cyan)
  color couleurAccent = color(0, 210, 255);
  
  // ========================================
  // CONSTRUCTEUR
  // ========================================
  
  // Initialise les paramètres avec les valeurs par défaut
  Parametres() {}
  
  // ========================================
  // LOGIQUE D'AFFICHAGE PRINCIPALE
  // ========================================
  
  /**
   * Dessine la page des paramètres avec tous les contrôles
   */
  void afficher() {
    // Fond selon le mode (sombre ou clair)
    background(modeSombre ? 10 : 240);
    
    // === TITRE DE LA PAGE ===
    textAlign(CENTER, TOP); 
    fill(couleurAccent); 
    textSize(40);
    text(langueFrancais ? "RÉGLAGES" : "SETTINGS", width/2, 50);
    
    // === OPTIONS TOGGLE (ON/OFF) ===
    // Espacement régulier de 120 pixels entre chaque option
    float yDebut = 200;
    float espacement = 120;
    
    dessinerOption(yDebut, langueFrancais ? "MODE SOMBRE" : "DARK MODE", modeSombre);
    dessinerOption(yDebut + espacement, langueFrancais ? "LANGUE : FR" : "LANGUAGE : EN", langueFrancais);
    dessinerOption(yDebut + espacement * 2, langueFrancais ? "SON" : "SOUND", sonActif);
    dessinerOption(yDebut + espacement * 3, langueFrancais ? "ACCESSIBILITÉ" : "ACCESSIBILITY", modeAccessibilite);

    // === SLIDER DE VOLUME ===
    dessinerSliderVolume(yDebut + espacement * 4);
    
    // === BOUTON DE VALIDATION ===
    dessinerBoutonRetour();
  }
  
  // ========================================
  // COMPOSANTS GRAPHIQUES (UI)
  // ========================================

  // Dessine un bouton bascule (Toggle) pour les options binaires
  void dessinerOption(float y, String titre, boolean etat) {
    float xB = width * 0.7;  // Position X du bouton toggle
    
    // Affichage du titre de l'option
    textAlign(LEFT, CENTER); 
    fill(modeSombre ? 255 : 50); 
    textSize(modeAccessibilite ? 28 : 22);  // Police agrandie si accessibilité activée
    text(titre, width * 0.2, y);

    // Dessin du bouton toggle
    rectMode(CENTER);
    stroke(couleurAccent);
    fill(etat ? couleurAccent : (modeSombre ? 40 : 200));
    rect(xB, y, 80, 40, 20);
    
    // Curseur circulaire mobile
    fill(etat ? 255 : 100); 
    ellipse(etat ? xB + 20 : xB - 20, y, 30, 30);
    rectMode(CORNER);
  }
  
  // Dessine la barre de réglage du volume avec curseur fluide

  void dessinerSliderVolume(float y) {
    textAlign(LEFT, CENTER); 
    fill(modeSombre ? 255 : 50); 
    textSize(modeAccessibilite ? 28 : 22);
    
    // Affiche le pourcentage actuel du volume
    String texteVolume = (langueFrancais ? "VOLUME : " : "VOLUME : ") + int(volumeSon * 100) + "%";
    text(texteVolume, width * 0.2, y);
    
    float xDebut = width * 0.58;
    float largeurBarre = 200;
    
    // Fond de la barre avec effet de profondeur
    fill(modeSombre ? 20 : 180);
    noStroke();
    rect(xDebut, y - 10, largeurBarre, 20, 10);
    
    // Partie remplie selon le volume (avec dégradé simulé)
    for (int i = 0; i < 3; i++) {
      fill(couleurAccent, 150 - i * 30);
      rect(xDebut + i, y - 8 + i, largeurBarre * volumeSon - i * 2, 16 - i * 2, 8);
    }
    
    // Curseur avec effet glow
    float xCurseur = xDebut + largeurBarre * volumeSon;
    
    // Glow du curseur (halos progressifs)
    for (int i = 3; i > 0; i--) {
      noStroke();
      fill(couleurAccent, 40);
      ellipse(xCurseur, y, 28 + i * 6, 28 + i * 6);
    }
    
    // Curseur principal
    stroke(couleurAccent);
    strokeWeight(3);
    fill(255);
    ellipse(xCurseur, y, 28, 28);
    
    // Point central du curseur
    noStroke();
    fill(couleurAccent);
    ellipse(xCurseur, y, 8, 8);
    
    // Icônes de volume aux extrémités
    textSize(16);
    textAlign(LEFT, CENTER);
    fill(modeSombre ? 120 : 80);
    
    textAlign(RIGHT, CENTER);
  }
  
  /**
   * Dessine le bouton de validation en bas de page
   */
  void dessinerBoutonRetour() {
    float y = height - 80;
    boolean survol = (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
                      mouseY > y - 25 && mouseY < y + 25);
    
    // Fond du bouton avec effet au survol
    fill(couleurAccent); 
    if(survol) stroke(255); 
    else noStroke();
    
    rectMode(CENTER); 
    rect(width/2, y, 200, 50, 10);
    
    // Texte du bouton (couleur inversée selon le mode)
    fill(modeSombre ? 0 : 255); 
    textAlign(CENTER, CENTER); 
    textSize(20);
    text(langueFrancais ? "VALIDER" : "CONFIRM", width/2, y - 3);
    rectMode(CORNER);
  }

  // ========================================
  // GESTION DES INTERACTIONS
  // ========================================
  
// Gère les clics de souris sur les différents contrôles

  void gererClic(int mx, int my) {
    float xB = width * 0.7;
    float yDebut = 200;
    float espacement = 120;
    
    // Détection des clics sur les boutons toggle (zone de 40px de rayon)
    if (dist(mx, my, xB, yDebut) < 40) {
      modeSombre = !modeSombre;
      println("Mode sombre : " + (modeSombre ? "activé" : "désactivé"));
    }
    if (dist(mx, my, xB, yDebut + espacement) < 40) {
      langueFrancais = !langueFrancais;
      println("Langue : " + (langueFrancais ? "Français" : "English"));
    }
    if (dist(mx, my, xB, yDebut + espacement * 2) < 40) {
      sonActif = !sonActif;
      println("Son : " + (sonActif ? "activé" : "désactivé"));
    }
    if (dist(mx, my, xB, yDebut + espacement * 3) < 40) {
      modeAccessibilite = !modeAccessibilite;
      println("Accessibilité : " + (modeAccessibilite ? "activée" : "désactivée"));
    }
    
    // Gestion du clic sur le slider de volume
    ajusterVolume(mx, my);
  }
  
// Gère le glissement de souris (drag) sur le slider de volume

  void gererDrag(int mx, int my) {
    ajusterVolume(mx, my);
  }
  
 // Calcule et ajuste le volume selon la position de la souris

  void ajusterVolume(int mx, int my) {
    float yDebut = 200;
    float espacement = 120;
    float yVolume = yDebut + espacement * 4;
    float xDebut = width * 0.58;
    float largeurBarre = 200;
    
    // Vérifie si la souris est dans la zone du slider (avec marge verticale et horizontale)
    if (my > yVolume - 40 && my < yVolume + 40 && 
        mx > xDebut - 30 && mx < xDebut + largeurBarre + 30) {
      
      // Calcule la position relative (0.0 à 1.0) et met à jour le volume
      float position = constrain((mx - xDebut) / largeurBarre, 0.0, 1.0);
      volumeSon = position;
      
      // Affichage dans la console pour debug
      println("Volume : " + int(volumeSon * 100) + "%");
    }
  }
  
 // Détecte si le bouton de validation a été cliqué

  boolean clicRetour(int mx, int my) {
    return (mx > width/2 - 100 && mx < width/2 + 100 && 
            my > height - 105 && my < height - 55);
  }
}
