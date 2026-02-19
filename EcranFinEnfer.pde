class EcranFinEnfer {
  
  Parametres reglages;
  
  int finActuelle = 1; // Quelle fin afficher (1-9)
  
  // Données des fins
  String[] titreFins;
  String[] messageFins;
  String[] emoteFins; // Emoji ou symbole pour chaque fin
  color[] couleurFins;
  
  // Animation
  float alpha = 0;
  float rotation = 0;
  
  // Particules
  float[] particuleX = new float[50];
  float[] particuleY = new float[50];
  float[] particuleVitesse = new float[50];
  color[] particuleCouleur = new color[50];
  
  EcranFinEnfer(Parametres r) {
    this.reglages = r;
    
    initialiserFins();
    initialiserParticules();
  }
  
  void initialiserFins() {
    titreFins = new String[10]; // Index 0 non utilisé, 1-9 pour les fins
    messageFins = new String[10];
    emoteFins = new String[10];
    couleurFins = new color[10];
    
    // FIN 1 : Flammes + Affronter
    titreFins[1] = reglages.langueFrancais ? "FIN N°1 - LE GUERRIER DES FLAMMES" : "ENDING #1 - FLAME WARRIOR";
    messageFins[1] = reglages.langueFrancais ?
      "Vous avez affronté les flammes avec bravoure.\n\n" +
      "Votre courage a impressionné Francis Ngannou.\n" +
      "Il vous accorde la liberté, mais vous êtes marqué à jamais\n" +
      "par les cicatrices du feu éternel.\n\n" +
      "Vous quittez l'Enfer, mais une partie de vous y restera."
      :
      "You faced the flames with bravery.\n\n" +
      "Your courage impressed Francis Ngannou.\n" +
      "He grants you freedom, but you are forever marked\n" +
      "by the scars of eternal fire.\n\n" +
      "You leave Hell, but a part of you will remain.";
    couleurFins[1] = color(255, 100, 0);
    
    // FIN 2 : Flammes + Traverser
    titreFins[2] = reglages.langueFrancais ? "FIN N°2 - LA RENAISSANCE" : "ENDING #2 - REBIRTH";
    messageFins[2] = reglages.langueFrancais ?
      "Vous avez traversé le brasier purificateur.\n\n" +
      "Les flammes ont consumé vos péchés.\n" +
      "Vous émergez transformé, purifié par le feu.\n\n" +
      "Francis Ngannou s'incline devant votre détermination.\n" +
      "Vous êtes libre, renaissant de vos cendres."
      :
      "You crossed the purifying inferno.\n\n" +
      "The flames consumed your sins.\n" +
      "You emerge transformed, purified by fire.\n\n" +
      "Francis Ngannou bows to your determination.\n" +
      "You are free, reborn from your ashes.";
    couleurFins[2] = color(255, 200, 0);
    
    // FIN 3 : Flammes + Embrasser
    titreFins[3] = reglages.langueFrancais ? "FIN N°3 - LE NOUVEAU GARDIEN" : "ENDING #3 - NEW GUARDIAN";
    messageFins[3] = reglages.langueFrancais ?
      "Vous avez embrassé le feu de l'Enfer.\n\n" +
      "Le pouvoir des flammes coule maintenant dans vos veines.\n" +
      "Francis Ngannou reconnaît en vous son successeur.\n\n" +
      "Vous ne quittez pas l'Enfer...\n" +
      "Car vous en devenez le nouveau maître."
      :
      "You embraced the fire of Hell.\n\n" +
      "The power of flames now flows through your veins.\n" +
      "Francis Ngannou recognizes you as his successor.\n\n" +
      "You don't leave Hell...\n" +
      "Because you become its new master.";
    couleurFins[3] = color(200, 0, 0);
    
    // FIN 4 : Ombres + Plonger
    titreFins[4] = reglages.langueFrancais ? "FIN N°4 - L'OMBRE ÉTERNELLE" : "ENDING #4 - ETERNAL SHADOW";
    messageFins[4] = reglages.langueFrancais ?
      "Vous avez plongé dans les profondeurs de l'obscurité.\n\n" +
      "Les ténèbres vous ont accepté comme l'un des leurs.\n" +
      "Vous existez maintenant entre deux mondes,\n" +
      "ni vivant ni mort, ni libre ni prisonnier.\n\n" +
      "Une existence éternelle dans l'ombre..."
      :
      "You dove into the depths of darkness.\n\n" +
      "The shadows accepted you as one of their own.\n" +
      "You now exist between two worlds,\n" +
      "neither alive nor dead, neither free nor imprisoned.\n\n" +
      "An eternal existence in shadow...";
    couleurFins[4] = color(100, 0, 150);
    
    // FIN 5 : Ombres + Suivre
    titreFins[5] = reglages.langueFrancais ? "FIN N°5 - LE MAÎTRE DES SECRETS" : "ENDING #5 - MASTER OF SECRETS";
    messageFins[5] = reglages.langueFrancais ?
      "Vous avez suivi les murmures dans les ténèbres.\n\n" +
      "Les secrets de l'Enfer vous ont été révélés.\n" +
      "Avec ce savoir interdit, vous manipulez\n" +
      "Francis Ngannou lui-même.\n\n" +
      "Vous quittez l'Enfer en connaissant ses faiblesses."
      :
      "You followed the whispers in the darkness.\n\n" +
      "The secrets of Hell were revealed to you.\n" +
      "With this forbidden knowledge, you manipulate\n" +
      "Francis Ngannou himself.\n\n" +
      "You leave Hell knowing its weaknesses.";
    couleurFins[5] = color(150, 0, 200);
    
    // FIN 6 : Ombres + Accepter
    titreFins[6] = reglages.langueFrancais ? "FIN N°6 - L'ACCEPTATION" : "ENDING #6 - ACCEPTANCE";
    messageFins[6] = reglages.langueFrancais ?
      "Vous avez accepté les ténèbres en vous.\n\n" +
      "La paix remplace la peur.\n" +
      "Francis Ngannou est surpris par votre sérénité.\n\n" +
      "Vous restez en Enfer... par choix.\n" +
      "Car vous avez trouvé votre place dans l'obscurité."
      :
      "You accepted the darkness within you.\n\n" +
      "Peace replaces fear.\n" +
      "Francis Ngannou is surprised by your serenity.\n\n" +
      "You stay in Hell... by choice.\n" +
      "Because you found your place in darkness.";
    couleurFins[6] = color(80, 0, 120);
    
    // FIN 7 : Chaos + Chevaucher
    titreFins[7] = reglages.langueFrancais ? "FIN N°7 - LE CAVALIER DU CHAOS" : "ENDING #7 - CHAOS RIDER";
    messageFins[7] = reglages.langueFrancais ?
      "Vous avez chevauché la tempête du chaos.\n\n" +
      "Votre esprit fragmenté contrôle maintenant\n" +
      "les forces imprévisibles de l'Enfer.\n\n" +
      "Francis Ngannou vous craint.\n" +
      "Vous êtes libre, mais instable, dangereux, imprévisible."
      :
      "You rode the storm of chaos.\n\n" +
      "Your fragmented mind now controls\n" +
      "the unpredictable forces of Hell.\n\n" +
      "Francis Ngannou fears you.\n" +
      "You are free, but unstable, dangerous, unpredictable.";
    couleurFins[7] = color(255, 150, 0);
    
    // FIN 8 : Chaos + Danser
    titreFins[8] = reglages.langueFrancais ? "FIN N°8 - LA DANSE ÉTERNELLE" : "ENDING #8 - ETERNAL DANCE";
    messageFins[8] = reglages.langueFrancais ?
      "Vous avez dansé avec le chaos.\n\n" +
      "Le rythme démentiel est devenu votre mélodie.\n" +
      "Vous et Francis Ngannou formez maintenant\n" +
      "une dualité parfaite.\n\n" +
      "Deux forces du chaos, dansant pour l'éternité."
      :
      "You danced with chaos.\n\n" +
      "The insane rhythm became your melody.\n" +
      "You and Francis Ngannou now form\n" +
      "a perfect duality.\n\n" +
      "Two forces of chaos, dancing for eternity.";
    couleurFins[8] = color(200, 100, 200);
    
    // FIN 9 : Chaos + Maîtriser
    titreFins[9] = reglages.langueFrancais ? "FIN N°9 - LE CONQUÉRANT" : "ENDING #9 - THE CONQUEROR";
    messageFins[9] = reglages.langueFrancais ?
      "Vous avez maîtrisé la folie.\n\n" +
      "Le chaos vous obéit, le désordre se plie à votre volonté.\n" +
      "Francis Ngannou s'agenouille devant vous.\n\n" +
      "Vous ne fuyez pas l'Enfer.\n" +
      "Vous le CONQUÉREZ et le reforgez à votre image."
      :
      "You mastered the madness.\n\n" +
      "Chaos obeys you, disorder bends to your will.\n" +
      "Francis Ngannou kneels before you.\n\n" +
      "You don't flee Hell.\n" +
      "You CONQUER it and reshape it in your image.";
    couleurFins[9] = color(255, 0, 100);
  }
  
  void initialiserParticules() {
    for (int i = 0; i < 50; i++) {
      particuleX[i] = random(width);
      particuleY[i] = random(height);
      particuleVitesse[i] = random(0.5, 2);
      particuleCouleur[i] = color(random(200, 255), random(0, 100), random(0, 100));
    }
  }
  
  void afficher(int numeroFin, int coups) {
    finActuelle = numeroFin;
    
    // Fond
    background(0);
    
    // Particules selon la couleur de la fin
    dessinerParticules();
    
    // Animation d'apparition
    if (alpha < 255) alpha += 3;
    
    // Panneau principal
    float panelW = width * 0.75;
    float panelH = height * 0.7;
    float panelX = width/2 - panelW/2;
    float panelY = height/2 - panelH/2;
    
    // Effet de lueur pulsante
    pushMatrix();
    translate(0, 0, 1);
    rotation += 0.02;
    for (int i = 30; i > 0; i -= 2) {
      float pulse = 1 + sin(frameCount * 0.05) * 0.2;
      fill(red(couleurFins[finActuelle]), green(couleurFins[finActuelle]), 
           blue(couleurFins[finActuelle]), 5);
      rect(panelX - i * pulse, panelY - i * pulse, 
           panelW + i * 2 * pulse, panelH + i * 2 * pulse, 30);
    }
    popMatrix();
    
    // Fond du panneau
    fill(0, 0, 0, 230);
    stroke(couleurFins[finActuelle], 200);
    strokeWeight(4);
    rect(panelX, panelY, panelW, panelH, 25);
    
    pushMatrix();
    translate(0, 0, 2);
    
    // Symbole de la fin (qui tourne)
    pushMatrix();
    translate(width/2, panelY + 90);
    rotate(rotation);
    
    for (int i = 8; i > 0; i--) {
      fill(couleurFins[finActuelle], 30 - i*3);
      textSize(80 + i*8);
      textAlign(CENTER, CENTER);
      text(emoteFins[finActuelle], 0, 0);
    }
    
    fill(couleurFins[finActuelle]);
    textSize(80);
    text(emoteFins[finActuelle], 0, 0);
    popMatrix();
    
    // Titre de la fin
    fill(couleurFins[finActuelle], alpha);
    textAlign(CENTER, TOP);
    textSize(32);
    text(titreFins[finActuelle], width/2, panelY + 170);
    
    // Ligne de séparation
    stroke(couleurFins[finActuelle], alpha/2);
    strokeWeight(2);
    line(panelX + 80, panelY + 220, panelX + panelW - 80, panelY + 220);
    
    // Message de la fin
    noStroke();
    fill(255, 240, 240, alpha);
    textAlign(CENTER, TOP);
    textSize(18);
    textLeading(28);
    text(messageFins[finActuelle], width/2, panelY + 250, panelW - 100, panelH - 350);
    
    // Statistiques
    fill(couleurFins[finActuelle], alpha * 0.8);
    textSize(20);
    text((reglages.langueFrancais ? "Accompli en " : "Completed in ") + coups + 
         (reglages.langueFrancais ? " coups" : " moves"), 
         width/2, panelY + panelH - 150);
    
    // Numéro de la fin avec style
    fill(couleurFins[finActuelle], alpha * 0.5);
    textSize(100);
    text(finActuelle, width/2, panelY + panelH - 100);
    
    // Bouton retour
    dessinerBoutonRetour();
    
    popMatrix();
  }
  
  void dessinerParticules() {
    for (int i = 0; i < 50; i++) {
      fill(couleurFins[finActuelle], 30);
      noStroke();
      
      for (int j = 3; j > 0; j--) {
        ellipse(particuleX[i], particuleY[i], 15 + j*5, 15 + j*5);
      }
      
      fill(couleurFins[finActuelle], 80);
      ellipse(particuleX[i], particuleY[i], 8, 8);
      
      particuleY[i] -= particuleVitesse[i];
      particuleX[i] += sin(frameCount * 0.02 + i) * 0.5;
      
      if (particuleY[i] < -20) {
        particuleY[i] = height + 20;
        particuleX[i] = random(width);
      }
    }
  }
  
  void dessinerBoutonRetour() {
    float btnW = 300;
    float btnH = 60;
    float btnX = width/2 - btnW/2;
    float btnY = height - 100;
    
    boolean survol = mouseX > btnX && mouseX < btnX + btnW &&
                     mouseY > btnY && mouseY < btnY + btnH;
    
    if (survol) {
      for (int i = 8; i > 0; i--) {
        fill(couleurFins[finActuelle], 15);
        rect(btnX - i, btnY - i, btnW + i*2, btnH + i*2, 15);
      }
      cursor(HAND);
    }
    
    fill(survol ? couleurFins[finActuelle] : color(50, 50, 50));
    stroke(couleurFins[finActuelle], 200);
    strokeWeight(2);
    rect(btnX, btnY, btnW, btnH, 12);
    
    fill(survol ? 0 : 255);
    textAlign(CENTER, CENTER);
    textSize(22);
    noStroke();
    text(reglages.langueFrancais ? "RETOUR AU MENU" : "BACK TO MENU", 
         btnX + btnW/2, btnY + btnH/2);
  }
  
  boolean clicRetour(int mx, int my) {
    float btnW = 300;
    float btnH = 60;
    float btnX = width/2 - btnW/2;
    float btnY = height - 100;
    
    return mx > btnX && mx < btnX + btnW && my > btnY && my < btnY + btnH;
  }
  
  void reinitialiser() {
    alpha = 0;
    rotation = 0;
    initialiserParticules();
  }
}
