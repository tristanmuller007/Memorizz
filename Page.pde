class Page {

  PApplet parent;
  
  Chargement chargement;
  PageAccueil accueil;
  ChoixGame choix;
  MemoryJeu jeuMemory;
  
  // COMPOSANTS ENFER
  MemoryEnfer jeuEnfer;
  DialogueEnfer dialogueEnfer;
  EcranFinEnfer ecranFinEnfer;
  
  Leaderboard classement;
  Parametres reglages;
  PageEasterEgg easterEgg;
  
  // Index de navigation
  int etape = -1;
  int niveauEnCours = 0; // 0=Intro, 1=Lvl1, 2=Lvl2

  Page(PApplet p) {
    this.parent = p;
    reglages = new Parametres();
    
    chargement = new Chargement();
    accueil = new PageAccueil(reglages);
    choix = new ChoixGame(reglages);
    classement = new Leaderboard(reglages);
    easterEgg = new PageEasterEgg(reglages);
    
    // Initialisation des composants Enfer
    // Note: jeuEnfer est instancié au moment du lancement pour être propre
    dialogueEnfer = new DialogueEnfer(reglages);
    ecranFinEnfer = new EcranFinEnfer(reglages);
    
    jeuMemory = null;
    jeuEnfer = null;
  }

  void dessiner() {
    color cFond = reglages.modeSombre ? color(5, 10, 25) : color(240);
    
    // --- ÉTAPE -1 : CHARGEMENT ---
    if (etape == -1) {
      background(cFond);
      chargement.dessinerTitre();
      chargement.dessinerChargement();
      if (chargement.chargementTermine) etape = 0;
      
    // --- ÉTAPE 0 : ACCUEIL ---
    } else if (etape == 0) {
      accueil.afficher(reglages.modeSombre, !reglages.langueFrancais);
      
    // --- ÉTAPE 1 : CONFIG ---
    } else if (etape == 1) {
      choix.afficherInterface(!reglages.langueFrancais);
      
    // --- ÉTAPE 2 : JEU NORMAL ---
    } else if (etape == 2) {
      if (jeuMemory != null) {
        jeuMemory.afficher();
        if (jeuMemory.nbPaireTrouvees == jeuMemory.nbPaires && !jeuMemory.jeuTerminee) {
          jeuMemory.jeuTerminee = true;
        }
        if (jeuMemory.jeuTerminee) jeuMemory.afficherVictoire();
      }
      
    // --- ÉTAPE 3 : PARAMÈTRES ---
    } else if (etape == 3) {
      reglages.afficher();
      
    // --- ÉTAPE 4 : LEADERBOARD ---
    } else if (etape == 4) {
      classement.afficher(!reglages.langueFrancais);
      
    // --- ÉTAPE 5 : EASTER EGG ---
    } else if (etape == 5) {
      easterEgg.afficher(!reglages.langueFrancais);
      
    // --- ÉTAPE 6 : JEU ENFER (BOUCLE NARRATIVE) ---
    } else if (etape == 6) {
      
      // 1. DESSINER LE JEU EN FOND
      if (jeuEnfer != null) jeuEnfer.afficher();
      
      // 2. DESSINER LE DIALOGUE (Si actif)
      if (dialogueEnfer.dialogueActif) {
        dialogueEnfer.afficher();
      }
      // 3. DESSINER VICTOIRE (Si jeu fini et pas encore en dialogue)
      else if (jeuEnfer != null && jeuEnfer.jeuTerminee && !dialogueEnfer.dialogueTermine) {
        jeuEnfer.afficherVictoire();
      }
      // 4. DESSINER FIN FINALE (Après dialogues)
      else if (dialogueEnfer.dialogueTermine) {
        ecranFinEnfer.afficher(dialogueEnfer.getFinObtenue(), (jeuEnfer!=null ? jeuEnfer.nbCoups : 0));
      }
    }
  }

  void gererDrag() {
    if (etape == 3) reglages.gererDrag(mouseX, mouseY);
  }

  void gererClic() {

    // --- ACCUEIL ---
    if (etape == 0) {
      if (accueil.clicSurEasterEgg(mouseX, mouseY)) {
        etape = 5;
        return;
      }
      String themeChoisi = accueil.detecterChoixPays(mouseX, mouseY);
      if (!themeChoisi.equals("")) {
        choix.selectionnerPaysParNom(themeChoisi);
        etape = 1;
      }
      if (dist(mouseX, mouseY, width - 70, 70) < 35) etape = 3;
      if (accueil.clicSurLeaderboard(mouseX, mouseY)) etape = 4;
      
    // --- CONFIG ---
    } else if (etape == 1) {
      choix.gererClicSouris(mouseX, mouseY);
      if (choix.clicSurRetour(mouseX, mouseY)) {
        etape = 0; accueil.reinitialiserCartes(); accueil.reinitialiserAnimation();
      }
      if (choix.lancementJeuDemande) {
        jeuMemory = new MemoryJeu(parent, reglages, choix.getThematiqueChoisie(), choix.getPaysChoisi(), choix.getSousThemeChoisi(), choix.getNbCartesChoisi());
        etape = 2; choix.lancementJeuDemande = false;
      }
      
    // --- JEU NORMAL ---
    } else if (etape == 2) {
      if (jeuMemory != null && !jeuMemory.jeuTerminee) jeuMemory.gererClic(mouseX, mouseY);
      
    // --- PARAMETRES ---
    } else if (etape == 3) {
      reglages.gererClic(mouseX, mouseY);
      if (reglages.clicRetour(mouseX, mouseY)) { etape = 0; accueil.reinitialiserAnimation(); }
      
    // --- CLASSEMENT ---
    } else if (etape == 4) {
      classement.gererClic(mouseX, mouseY);
      if (classement.clicRetour(mouseX, mouseY)) { etape = 0; accueil.reinitialiserAnimation(); }
      
    // --- EASTER EGG ---
    } else if (etape == 5) {
      if (easterEgg.clicSurRetour(mouseX, mouseY)) {
        etape = 0; easterEgg.reinitialiserCarte(); accueil.reinitialiserCartes();
      }
      String themeChoisi = easterEgg.detecterChoixTheme(mouseX, mouseY);
      if (themeChoisi.equals("ENFER")) {
        // LANCEMENT DU MODE ENFER
        etape = 6;
        niveauEnCours = 0; // Intro
        jeuEnfer = new MemoryEnfer(parent, reglages); // Init du jeu
        dialogueEnfer.demarrer(); // Lance Intro Dialogue
      }
      
    // --- ENFER ---
    } else if (etape == 6) {
      
      // A. DIALOGUE ACTIF
      if (dialogueEnfer.dialogueActif) {
        dialogueEnfer.gererClic(mouseX, mouseY);
        
        // TRANSITION : Dialogue -> Jeu
        if (dialogueEnfer.lancerProchainNiveau) {
           dialogueEnfer.lancerProchainNiveau = false;
           niveauEnCours++; // 0->1 ou 1->2
           jeuEnfer.reinitialiserPourNiveau(niveauEnCours);
        }
        return;
      }
      
      // B. FIN FINALE
      if (dialogueEnfer.dialogueTermine) {
        if (ecranFinEnfer.clicRetour(mouseX, mouseY)) {
          etape = 0; jeuEnfer = null; accueil.reinitialiserCartes();
        }
        return;
      }
      
      // C. JEU EN COURS
      if (jeuEnfer != null && !jeuEnfer.jeuTerminee) {
        jeuEnfer.gererClic(mouseX, mouseY);
      }
    }
  }

  void gererTouche() {
    if (etape == 4 && classement.saisieNomActive) {
      classement.ecrireNom(key); key = 0; return;
    }

    // --- CHEAT CODE 'H' (ENFER) ---
    if ((key == 'h' || key == 'H') && etape == 6 && jeuEnfer != null && !jeuEnfer.jeuTerminee) {
      jeuEnfer.terminerAutomatiquement();
      return;
    }

    // --- ESPACE (FIN JEU NORMAL) ---
    if (etape == 2 && jeuMemory != null && jeuMemory.jeuTerminee && key == ' ') {
        if (!jeuMemory.isScoreEnregistre()) {
          classement.ajouterScore("", jeuMemory.getTempsEnSecondes(), jeuMemory.getCoups(), jeuMemory.thematique, jeuMemory.pays, jeuMemory.getDifficulte());
          jeuMemory.marquerScoreEnregistre();
        }
        jeuMemory.arreterTousLesSons(); jeuMemory = null; etape = 4;
    }
    
    // --- ESPACE (FIN NIVEAU ENFER -> DIALOGUE) ---
    if (etape == 6 && jeuEnfer != null && jeuEnfer.jeuTerminee && key == ' ') {
      // Si on n'est pas déjà en dialogue et pas à la fin finale
      if (!dialogueEnfer.dialogueActif && !dialogueEnfer.dialogueTermine) {
         dialogueEnfer.dialogueActif = true;
         // Si fin niveau 1 -> Choix
         if (niveauEnCours == 1) dialogueEnfer.etapeDialogue = 2;
         dialogueEnfer.progression = 0;
         dialogueEnfer.alpha = 0;
      }
    }

    // --- ESC ---
    if (key == ESC) {
      key = 0;
      if (etape == 4 && classement.saisieNomActive) { classement.saisieNomActive = false; classement.nomJoueur = ""; return; }
      if (etape == 2) { jeuMemory.arreterTousLesSons(); etape = 1; jeuMemory = null; }
      else if (etape == 6) { etape = 5; jeuEnfer = null; }
      else if (etape == 5) { etape = 0; easterEgg.reinitialiserCarte(); accueil.reinitialiserCartes(); }
      else if (etape != 0) { etape = 0; jeuMemory = null; jeuEnfer = null; accueil.reinitialiserCartes(); accueil.reinitialiserAnimation(); }
    }
  }
}
