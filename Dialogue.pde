class DialogueEnfer {
  
  Parametres reglages;
  
  // États du dialogue
  // 0-1 : Intro
  // 2 : Choix Niveau 1 (Flammes/Ombres/Chaos)
  // 3-5 : Choix Niveau 2 (Selon le premier choix)
  int etapeDialogue = 0; 
  
  boolean dialogueActif = false;
  boolean dialogueTermine = false;
  
  boolean lancerProchainNiveau = false;
  
  // Contenu des dialogues
  String[] titres;
  String[] textes;
  String[] boutons;
  
  // Choix du joueur
  int choixNiveau1 = -1; 
  int choixNiveau2 = -1;
  int finObtenue = -1;
  
  // Animation
  float alpha = 0;
  float progression = 0;
  
  // Particules infernales
  float[] flameX = new float[30];
  float[] flameY = new float[30];
  float[] flameSize = new float[30];
  
  DialogueEnfer(Parametres r) {
    this.reglages = r;
    for (int i = 0; i < 30; i++) {
      flameX[i] = random(width);
      flameY[i] = height + random(100);
      flameSize[i] = random(20, 60);
    }
    initialiserDialogues();
  }
  
  void initialiserDialogues() {
    titres = new String[10];
    textes = new String[10];
    boutons = new String[10];
    
    // --- PARTIE 1 : INTRO ---
    
    // DIALOGUE 0 : RÈGLES
    titres[0] = reglages.langueFrancais ? "RÈGLES DE L'ENFER" : "RULES OF HELL";
    textes[0] = reglages.langueFrancais ? 
      "Bienvenue dans le défi ultime.\n\n" +
      "- Retrouvez les paires avant que le temps ne s'écoule.\n" +
      "- NIVEAU 1 : Mélange toutes les 5 secondes.\n" +
      "- NIVEAU 2 : Mélange toutes les 3 secondes.\n" +
      "- Survivez aux deux niveaux pour changer votre destin." 
      : 
      "Welcome to the ultimate challenge.\n\n" +
      "- Find pairs before time runs out.\n" +
      "- LEVEL 1: Shuffles every 5 seconds.\n" +
      "- LEVEL 2: Shuffles every 3 seconds.\n" +
      "- Survive both levels to change your destiny.";
    boutons[0] = reglages.langueFrancais ? "SUIVANT" : "NEXT";
    
    // DIALOGUE 1 : LORE (Lancement Niveau 1)
    titres[1] = reglages.langueFrancais ? "VOTRE DESTINÉE" : "YOUR DESTINY";
    textes[1] = reglages.langueFrancais ?
      "Vous êtes tombé en Enfer.\n" +
      "Francis Ngannou, gardien de ce royaume, vous observe.\n\n" +
      "« Prouve ta valeur, mortel. Si tu survis à ma première\n" +
      "épreuve, je te laisserai peut-être choisir ton sort. »\n\n" +
      "Préparez-vous..."
      :
      "You have fallen into Hell.\n" +
      "Francis Ngannou, guardian of this realm, watches you.\n\n" +
      "\"Prove your worth, mortal. If you survive my first\n" +
      "trial, I might let you choose your fate.\"\n\n" +
      "Get ready...";
    boutons[1] = reglages.langueFrancais ? "AFFRONTER LE NIVEAU 1" : "FACE LEVEL 1";
    
    // --- PARTIE 2 : APRÈS NIVEAU 1 ---
    
    // DIALOGUE 2 : PREMIER CHOIX (Lancement Niveau 2)
    titres[2] = reglages.langueFrancais ? "PREMIÈRE ÉPREUVE RÉUSSIE" : "FIRST TRIAL CLEARED";
    textes[2] = reglages.langueFrancais ?
      "Vous avez survécu, mais le plus dur reste à venir.\n\n" +
      "Ngannou hoche la tête : « Intéressant... \n" +
      "Choisis maintenant la voie de ta souffrance.\n" +
      "Cela déterminera ta prochaine épreuve. »"
      :
      "You survived, but the hardest part is yet to come.\n\n" +
      "Ngannou nods: \"Interesting... \n" +
      "Now choose the path of your suffering.\n" +
      "This will determine your next trial.\"";
    // Pas de bouton ici, ce sont les 3 choix qui s'affichent
  }
  
  void demarrer() {
    dialogueActif = true;
    dialogueTermine = false;
    lancerProchainNiveau = false;
    etapeDialogue = 0;
    alpha = 0;
    progression = 0;
  }
  
  void afficher() {
    if (!dialogueActif) return;
    
    // Animation d'apparition
    if (alpha < 255) alpha += 5;
    
    // Fond sombre
    fill(0, 0, 0, min(alpha, 230));
    rect(0, 0, width, height);
    
    dessinerFlammes();
    
    // Panneau
    float panelW = width * 0.7;
    float panelH = height * 0.65;
    float panelX = width/2 - panelW/2;
    float panelY = height/2 - panelH/2;
    
    // Cadre rougeoyant
    fill(15, 0, 0, min(alpha, 240));
    stroke(255, 50, 50, min(alpha, 200));
    strokeWeight(3);
    rect(panelX, panelY, panelW, panelH, 20);
    
    pushMatrix();
    translate(0, 0, 2);
    
    // Titre
    fill(255, 100, 0, alpha);
    textAlign(CENTER, TOP);
    textSize(38);
    text(titres[etapeDialogue], width/2, panelY + 40);
    
    // Ligne
    stroke(255, 50, 50, alpha/2);
    strokeWeight(2);
    line(panelX + 60, panelY + 100, panelX + panelW - 60, panelY + 100);
    
    // Texte défilant
    noStroke();
    fill(255, 200, 200, alpha);
    textAlign(LEFT, TOP);
    textSize(18);
    textLeading(26);
    
    String texteComplet = textes[etapeDialogue];
    if (progression < texteComplet.length()) progression += 0.5;
    
    String texteVisible = texteComplet.substring(0, min((int)progression, texteComplet.length()));
    text(texteVisible, panelX + 60, panelY + 130, panelW - 120, panelH - 250);
    
    // Affichage des contrôles (Bouton ou Choix)
    if (progression >= texteComplet.length() - 1) {
      if (etapeDialogue == 2 || (etapeDialogue >= 3 && etapeDialogue <= 5)) {
        dessinerTroisChoix(panelX, panelY, panelW, panelH);
      } else {
        dessinerBoutonContinuer(panelX, panelY, panelW, panelH);
      }
    }
    
    popMatrix();
  }
  
  void dessinerBoutonContinuer(float panelX, float panelY, float panelW, float panelH) {
    float btnY = panelY + panelH - 80;
    float btnW = 300;
    float btnH = 55;
    float btnX = width/2 - btnW/2;
    boolean survol = mouseX > btnX && mouseX < btnX + btnW && mouseY > btnY && mouseY < btnY + btnH;
    
    if (survol) {
      cursor(HAND);
      fill(255, 100, 0, 20);
      rect(btnX-5, btnY-5, btnW+10, btnH+10, 15);
    }
    
    fill(survol ? color(255, 100, 0) : color(150, 50, 0));
    stroke(255, 150, 0, 200);
    strokeWeight(2);
    rect(btnX, btnY, btnW, btnH, 12);
    
    fill(survol ? 0 : 255);
    textAlign(CENTER, CENTER);
    textSize(22);
    text(boutons[etapeDialogue], btnX + btnW/2, btnY + btnH/2);
  }
  
  void dessinerTroisChoix(float panelX, float panelY, float panelW, float panelH) {
    String[] choix;
    // Choix Niveau 1 (Pour aller au Niveau 2)
    if (etapeDialogue == 2) {
      choix = reglages.langueFrancais ? 
        new String[] { "Chemin des Flammes", "Chemin des Ombres", "Chemin du Chaos" } :
        new String[] { "Path of Flames", "Path of Shadows", "Path of Chaos" };
    } 
    // Choix Finaux (Après Niveau 2)
    else {
      choix = obtenirChoixNiveau2();
    }
    
    float btnW = 280; float btnH = 65; float espacement = 25;
    float startY = panelY + panelH - 100;
    float startX = width/2 - (btnW * 3 + espacement * 2)/2;
    
    for (int i = 0; i < 3; i++) {
      float btnX = startX + i * (btnW + espacement);
      boolean survol = mouseX > btnX && mouseX < btnX + btnW && mouseY > startY && mouseY < startY + btnH;
      if (survol) {
        cursor(HAND);
        fill(255, 255, 255, 20);
        rect(btnX-5, startY-5, btnW+10, btnH+10, 15);
      }
      
      color btnColor = (i==0) ? color(255, 50, 0) : (i==1) ? color(100, 0, 150) : color(255, 150, 0);
      fill(survol ? btnColor : color(red(btnColor)*0.5, green(btnColor)*0.5, blue(btnColor)*0.5));
      stroke(btnColor, 200);
      rect(btnX, startY, btnW, btnH, 10);
      
      fill(survol ? 0 : 255);
      textAlign(CENTER, CENTER);
      textSize(16);
      text(choix[i], btnX + btnW/2, startY + btnH/2);
    }
  }

  void gererClic(int mx, int my) {
    if (!dialogueActif) return;
    
    // Si le texte n'a pas fini de s'écrire, on l'affiche d'un coup
    if (progression < textes[etapeDialogue].length() - 1) {
      progression = textes[etapeDialogue].length();
      return;
    }
    
    // Clic sur les choix (3 boutons)
    if (etapeDialogue == 2) {
      gererClicTroisChoix(mx, my, true); // Choix Niveau 1 -> Lance Niveau 2
    } else if (etapeDialogue >= 3 && etapeDialogue <= 5) {
      gererClicTroisChoix(mx, my, false); // Choix Niveau 2 -> Lance Fin
    } 
    // Clic sur bouton Continuer
    else {
      float panelW = width * 0.7; float panelH = height * 0.65;
      float panelY = height/2 - panelH/2;
      float btnY = panelY + panelH - 80; float btnW = 300; float btnH = 55; float btnX = width/2 - btnW/2;
      
      if (mx > btnX && mx < btnX + btnW && my > btnY && my < btnY + btnH) {
        // Si on est à l'étape 1 (Fin de l'Intro), on lance le jeu
        if (etapeDialogue == 1) {
           lancerProchainNiveau = true;
           dialogueActif = false;
        } else {
           // Sinon on passe juste au texte suivant (Règles -> Lore)
           etapeSuivante();
        }
      }
    }
  }
  
  void gererClicTroisChoix(int mx, int my, boolean premierNiveau) {
    float panelH = height * 0.65; float panelY = height/2 - panelH/2;
    float btnW = 280; float btnH = 65; float espacement = 25;
    float startY = panelY + panelH - 100;
    float startX = width/2 - (btnW * 3 + espacement * 2)/2;
    
    for (int i = 0; i < 3; i++) {
      float btnX = startX + i * (btnW + espacement);
      if (mx > btnX && mx < btnX + btnW && my > startY && my < startY + btnH) {
        
        if (premierNiveau) {
          // On a choisi le premier chemin (Flammes/Ombres/Chaos)
          choixNiveau1 = i;
          etapeDialogue = 3 + i; // On prépare le texte qui s'affichera APRÈS le niveau 2
          preparerTexteChoix1(i);
          
          // ON LANCE LE NIVEAU 2
          lancerProchainNiveau = true;
          dialogueActif = false;
        } else {
          // On a fait le choix final
          choixNiveau2 = i;
          calculerFin();
          dialogueTermine = true; // Déclenche l'écran de fin
        }
        progression = 0;
        break;
      }
    }
  }
  
  String[] obtenirChoixNiveau2() {
    if (reglages.langueFrancais) {
      if (choixNiveau1 == 0) return new String[] { "Affronter les Flammes", "Traverser le Brasier", "Embrasser le Feu" };
      else if (choixNiveau1 == 1) return new String[] { "Plonger dans l'Obscurité", "Suivre les Murmures", "Accepter les Ténèbres" };
      else return new String[] { "Chevaucher la Tempête", "Danser avec le Chaos", "Maîtriser la Folie" };
    } else {
      if (choixNiveau1 == 0) return new String[] { "Face the Flames", "Cross the Inferno", "Embrace the Fire" };
      else if (choixNiveau1 == 1) return new String[] { "Dive into Darkness", "Follow the Whispers", "Accept the Shadows" };
      else return new String[] { "Ride the Storm", "Dance with Chaos", "Master the Madness" };
    }
  }
  
  void preparerTexteChoix1(int choix) {
    // Ce texte s'affichera APRÈS avoir gagné le niveau 2
    if (reglages.langueFrancais) {
      if (choix == 0) {
        titres[3] = "LE CHEMIN DES FLAMMES";
        textes[3] = "Vous avez traversé l'enfer une seconde fois.\n" +
                    "La chaleur est insoutenable.\n" +
                    "Ngannou apparaît dans un tourbillon de feu.\n\n" +
                    "« Tu as prouvé ta force. Maintenant, décide de ton sort ! »";
      } else if (choix == 1) {
        titres[4] = "LE CHEMIN DES OMBRES";
        textes[4] = "L'obscurité a tenté de vous consumer, mais vous avez résisté.\n" +
                    "Ngannou émerge de l'ombre.\n\n" +
                    "« Les ténèbres te respectent. Quelle est ta volonté ? »";
      } else {
        titres[5] = "LE CHEMIN DU CHAOS";
        textes[5] = "La réalité s'est brisée, mais votre esprit a tenu bon.\n" +
                    "Ngannou rit dans le tumulte.\n\n" +
                    "« Le chaos t'obéit. Que vas-tu en faire ? »";
      }
    } else {
       // Version anglaise simplifiée
       if (choix == 0) { titres[3] = "PATH OF FLAMES"; textes[3] = "You survived. Choose your fate!"; }
       else if (choix == 1) { titres[4] = "PATH OF SHADOWS"; textes[4] = "Darkness respects you. What is your will?"; }
       else { titres[5] = "PATH OF CHAOS"; textes[5] = "Chaos obeys you. What will you do?"; }
    }
    boutons[etapeDialogue] = reglages.langueFrancais ? "CHOISIR MA FIN" : "CHOOSE MY ENDING";
  }
  
  void calculerFin() { 
    finObtenue = choixNiveau1 * 3 + choixNiveau2 + 1; 
  }
  
  void etapeSuivante() { 
    etapeDialogue++; 
    progression = 0; 
  }
  
  void dessinerFlammes() { 
    for(int i=0; i<30; i++) {
       fill(255, 100, 0, 40); noStroke();
       ellipse(flameX[i], flameY[i], flameSize[i], flameSize[i]*1.5);
       flameY[i] -= 2; flameX[i] += sin(frameCount*0.05+i);
       if(flameY[i] < -50) { flameY[i] = height+50; flameX[i] = random(width); }
    }
  }
  
  int getFinObtenue() { return finObtenue; }
}
