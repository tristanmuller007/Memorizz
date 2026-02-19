import processing.sound.*;

class GestionnaireImages {

  PApplet parent;

  HashMap<String, HashMap<String, HashMap<String, PImage[]>>> bibliothequeImages;
  PImage imageDos;

  HashMap<String, SoundFile[]> bibliothequeHymnes;

  final int NB_IMAGES_MAX = 18;
  final int NB_IMAGES_ENFER = 32;

  GestionnaireImages(PApplet p) {
    this.parent = p;
    bibliothequeImages = new HashMap<String, HashMap<String, HashMap<String, PImage[]>>>();
    bibliothequeHymnes = new HashMap<String, SoundFile[]>();
    chargerTouteImages();
  }

  void chargerTouteImages() {
    chargerThematiquePays();
    chargerThematiqueGeo();
    chargerThematiqueLibre();
  }

  void chargerThematiquePays() {
    HashMap<String, HashMap<String, PImage[]>> themePays = new HashMap<String, HashMap<String, PImage[]>>();

    // France
    HashMap<String, PImage[]> france = new HashMap<String, PImage[]>();
    france.put("GASTRONOMIE", chargerImagesOuCreer("pays/france/gastronomie/", "FRA_GASTRO"));
    france.put("MARQUES", chargerImagesOuCreer("pays/france/marques/", "FRA_MARQUE"));
    france.put("HISTOIRE", chargerImagesOuCreer("pays/france/histoire/", "FRA_HIST"));
    themePays.put("La France", france);

    // Allemagne
    HashMap<String, PImage[]> allemagne = new HashMap<String, PImage[]>();
    allemagne.put("GASTRONOMIE", chargerImagesOuCreer("pays/allemagne/gastronomie/", "ALL_GASTRO"));
    allemagne.put("MARQUES", chargerImagesOuCreer("pays/allemagne/marques/", "ALL_MARQUE"));
    allemagne.put("HISTOIRE", chargerImagesOuCreer("pays/allemagne/histoire/", "ALL_HIST"));
    themePays.put("L'Allemagne", allemagne);

    // Turquie
    HashMap<String, PImage[]> turquie = new HashMap<String, PImage[]>();
    turquie.put("GASTRONOMIE", chargerImagesOuCreer("pays/turquie/gastronomie/", "TUR_GASTRO"));
    turquie.put("MARQUES", chargerImagesOuCreer("pays/turquie/lieux/", "TUR_MARQUE"));
    turquie.put("HISTOIRE", chargerImagesOuCreer("pays/turquie/histoire/", "TUR_HIST"));
    themePays.put("La Turquie", turquie);

    bibliothequeImages.put("PAYS", themePays);
  }

  void chargerThematiqueGeo() {
    HashMap<String, HashMap<String, PImage[]>> themeGeo = new HashMap<String, HashMap<String, PImage[]>>();

    HashMap<String, PImage[]> pays = new HashMap<String, PImage[]>();
    pays.put("DRAPEAU", chargerImagesOuCreer("geo/pays/drapeau/", "PAY_DRAPE"));
    pays.put("PAYSAGE/CAPITAL", chargerImagesOuCreer("geo/pays/capital/", "PAY_CAPIT"));
    
    // Chargement des hymnes avec association aux drapeaux
    pays.put("HYMNE", chargerImagesHymne("geo/pays/drapeau/", "PAY_HYMNE", "PAYS"));
    
    themeGeo.put("PAYS", pays);

    bibliothequeImages.put("GEOGRAPHIE", themeGeo);
  }

  void chargerThematiqueLibre() {
    HashMap<String, HashMap<String, PImage[]>> themeLibre = new HashMap<String, HashMap<String, PImage[]>>();
    
    HashMap<String, PImage[]> animaux = new HashMap<String, PImage[]>();
    animaux.put("DOMESTIQUES", chargerImagesOuCreer("libre/animaux/domestiques/", "ANI_DOMES"));
    animaux.put("SAUVAGES", chargerImagesOuCreer("libre/animaux/sauvages/", "ANI_SAUVA")); 
    themeLibre.put("Animaux", animaux);
    
    HashMap<String, PImage[]> nature = new HashMap<String, PImage[]>();
    nature.put("PLANTES", chargerImagesOuCreer("libre/nature/plantes/", "NAT_PLANTE"));
    themeLibre.put("Nature", nature);
   
    HashMap<String, PImage[]> sports = new HashMap<String, PImage[]>();
    sports.put("COLLECTIFS", chargerImagesOuCreer("libre/sports/collectifs/", "SPO_COLLE"));
    sports.put("INDIVIDUELS", chargerImagesOuCreer("libre/sports/individuels/", "SPO_INDIV"));
    themeLibre.put("Sports", sports);

    bibliothequeImages.put("LIBRE", themeLibre);
  }

  PImage[] chargerImagesEnfer() {
    PImage[] images = new PImage[NB_IMAGES_ENFER];

    for (int i = 0; i < NB_IMAGES_ENFER; i++) {
      String nomFichier = "enfer/" + i + ".png";

      try {
        File f = dataFile(nomFichier);
        if (f.exists()) {
          images[i] = loadImage(nomFichier);
          println("Image Enfer chargée: " + nomFichier);
        } else {
          images[i] = creerImageEnfer(i);
          println("Image Enfer générée: " + i);
        }
      } catch (Exception e) {
        images[i] = creerImageEnfer(i);
        println("Erreur chargement Enfer " + i + ", génération procédurale");
      }
    }

    return images;
  }

  PImage creerImageEnfer(int index) {
    PGraphics pg = createGraphics(200, 150);
    pg.beginDraw();
    pg.background(60, 0, 0);
    pg.stroke(255, 50, 50);
    pg.strokeWeight(3);
    pg.noFill();
    pg.rect(5, 5, 190, 140, 10);
    pg.fill(255, 100, 100);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(16);
    pg.text("ENFER", 100, 30);
    pg.textSize(50);
    pg.fill(255, 150, 150);
    pg.text(index + 1, 100, 90);
    pg.noStroke();
    for (int i = 0; i < 5; i++) {
      float x = 40 + i * 30;
      float y = 120 + random(-5, 5);
      pg.fill(255, 100, 0, 100);
      pg.ellipse(x, y, 15, 25);
      pg.fill(255, 200, 0, 150);
      pg.ellipse(x, y + 5, 10, 15);
    }
    pg.stroke(255, 0, 0, 80);
    pg.strokeWeight(2);
    pg.noFill();
    float cx = 170, cy = 25, r = 12;
    pg.beginShape();
    for (int i = 0; i < 5; i++) {
      float angle = i * TWO_PI * 2 / 5 - HALF_PI;
      pg.vertex(cx + cos(angle) * r, cy + sin(angle) * r);
    }
    pg.endShape(CLOSE);
    pg.endDraw();
    return pg;
  }

  PImage[] chargerImagesOuCreer(String chemin, String prefix) {
    PImage[] images = new PImage[NB_IMAGES_MAX];

    for (int i = 0; i < NB_IMAGES_MAX; i++) {
      String nomFichier = chemin + i + ".png";

      try {
        File f = dataFile(nomFichier);
        if (f.exists()) {
          images[i] = loadImage(nomFichier);
        } else {
          images[i] = creerImageProcedurale(prefix, i);
        }
      } catch (Exception e) {
        images[i] = creerImageProcedurale(prefix, i);
      }
    }

    return images;
  }

  PImage[] chargerImagesHymne(String cheminImages, String prefix, String pays) {
    PImage[] images = new PImage[NB_IMAGES_MAX];
    SoundFile[] hymnes = new SoundFile[NB_IMAGES_MAX];

    println("🎵 === CHARGEMENT HYMNES POUR : " + pays + " ===");

    // Chemin vers les fichiers audio
    String cheminAudio = "geo/pays/hymne/";

    for (int i = 0; i < NB_IMAGES_MAX; i++) {
      
      // 1. CHARGEMENT DE L'IMAGE (Drapeau)
      String nomFichierImage = cheminImages + i + ".png";
      
      try {
        File f = dataFile(nomFichierImage);
        if (f.exists()) {
          images[i] = loadImage(nomFichierImage);
          println(" Image " + i + " chargée : " + nomFichierImage);
        } else {
          images[i] = creerImagesDrapeauPays(pays, i);
          println(" Image " + i + " générée (fichier manquant)");
        }
      } catch (Exception e) {
        images[i] = creerImagesDrapeauPays(pays, i);
        println(" Image " + i + " générée (erreur)");
      }
      
      // 2. CHARGEMENT DE L'AUDIO (Hymne)
      String nomFichierAudio = cheminAudio + i + ".mp3";
      
      try {
        File fAudio = dataFile(nomFichierAudio);
        if (fAudio.exists()) {
          hymnes[i] = new SoundFile(this.parent, nomFichierAudio);
          println(" Hymne " + i + " chargé : " + nomFichierAudio);
        } else {
          println(" Hymne " + i + " non trouvé : " + nomFichierAudio);
          hymnes[i] = null;
        }
      } catch (Exception e) {
        println(" Erreur chargement hymne " + i + " : " + e.getMessage());
        hymnes[i] = null;
      }
    }

    // 3. SAUVEGARDE DES HYMNES DANS LA BIBLIOTHÈQUE
    bibliothequeHymnes.put(pays, hymnes);
    
    int nbHymnesCharges = 0;
    for (SoundFile h : hymnes) {
      if (h != null) nbHymnesCharges++;
    }
    println(" Total hymnes chargés : " + nbHymnesCharges + "/" + NB_IMAGES_MAX);
    println("===========================================\n");

    return images;
  }

  PImage creerImagesDrapeauPays(String pays, int index) {
    PGraphics pg = createGraphics(200, 150);
    pg.beginDraw();

    color[] couleurPays = getCouleursPays(pays);

    pg.background(255);

    pg.noStroke();
    int nbBandes = couleurPays.length;
    float hauteurBande = 150.0 / nbBandes;

    for (int i = 0; i < nbBandes; i++) {
      pg.fill(couleurPays[i]);
      pg.rect(0, i * hauteurBande, 200, hauteurBande);
    }

    pg.fill(255, 200);
    pg.noStroke();
    pg.textAlign(CENTER, CENTER);
    pg.textSize(20);
    pg.text(pays, 100, 30);

    pg.endDraw();
    return pg;
  }

  color[] getCouleursPays(String pays) {
    if (pays.equals("Russie")) {
      return new color[] {
        color(255, 255, 255),
        color(0, 57, 166),
        color(213, 43, 30)
      };
    } else if (pays.equals("Afrique du Sud")) {
      return new color[] {
        color(0, 122, 77),
        color(0, 0, 0),
        color(255, 255, 255),
        color(255, 182, 18),
        color(224, 60, 49),
        color(0, 35, 149)
      };
    } else if (pays.equals("Portugal")) {
      return new color[] {
        color(0, 102, 0),
        color(255, 0, 0)
      };
    }
    return new color[] {
      color(100),
      color(150),
      color(200)
    };
  }

  PImage creerImageProcedurale(String prefix, int index) {
    PGraphics pg = createGraphics(200, 150);
    pg.beginDraw();

    color fondCouleur = getCouleurTheme(prefix);
    pg.background(fondCouleur);

    pg.stroke(255);
    pg.strokeWeight(3);
    pg.noFill();
    pg.rect(5, 5, 190, 140, 10);

    pg.fill(255);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(16);
    pg.text(prefix, 100, 30);

    pg.textSize(60);
    pg.text(index + 1, 100, 90);

    dessinerFormeDistinctive(pg, prefix, index);

    pg.endDraw();
    return pg;
  }

  color getCouleurTheme(String prefix) {
    if (prefix.startsWith("FRA")) return color(0, 85, 164);
    if (prefix.startsWith("ALL")) return color(221, 0, 0);
    if (prefix.startsWith("TUR")) return color(0, 146, 70);
    if (prefix.startsWith("RUS")) return color(0, 57, 166);
    if (prefix.startsWith("AFS")) return color(255, 182, 18);
    if (prefix.startsWith("POR")) return color(0, 102, 0);
    if (prefix.startsWith("ANI")) return color(34, 139, 34);
    if (prefix.startsWith("NAT")) return color(46, 125, 50);
    if (prefix.startsWith("SPO")) return color(255, 152, 0);

    return color(100, 100, 100);
  }

  void dessinerFormeDistinctive(PGraphics pg, String prefix, int index) {
    pg.noStroke();
    pg.fill(255, 200);

    if (prefix.contains("GASTRO")) {
      pg.ellipse(100, 120, 30, 30);
      pg.rect(85, 105, 30, 15);
    } else if (prefix.contains("MARQUE")) {
      pg.rect(70, 110, 60, 25, 5);
      pg.fill(getCouleurTheme(prefix));
      pg.rect(75, 115, 50, 15);
    } else if (prefix.contains("HIST")) {
      pg.rect(90, 100, 20, 40);
      pg.triangle(80, 100, 100, 85, 120, 100);
    } else if (prefix.contains("HYMNE")) {
      for (int i = 0; i < 5; i++) {
        pg.ellipse(70 + i * 15, 120, 8, 8);
      }
    } else if (prefix.contains("DRAPE")) {
      pg.rect(80, 100, 40, 30);
      pg.rect(75, 95, 5, 40);
    } else if (prefix.contains("CAPIT")) {
      pg.stroke(255);
      pg.strokeWeight(3);
      pg.noFill();
      pg.beginShape();
      for (int i = 0; i < 6; i++) {
        pg.vertex(60 + i * 15, 110 + (i % 2) * 10);
      }
      pg.endShape();
    } else if (prefix.contains("DOMEST") || prefix.contains("SAUVAG")) {
      pg.ellipse(100, 115, 20, 25);
      pg.ellipse(90, 105, 12, 12);
      pg.ellipse(100, 100, 12, 12);
      pg.ellipse(110, 105, 12, 12);
    } else if (prefix.contains("NAT")) {
      pg.ellipse(100, 115, 30, 40);
      pg.stroke(255, 200);
      pg.strokeWeight(2);
      pg.line(100, 95, 100, 125);
    } else if (prefix.contains("SPO")) {
      pg.ellipse(100, 115, 35, 35);
      pg.stroke(getCouleurTheme(prefix));
      pg.strokeWeight(2);
      pg.noFill();
      pg.arc(100, 115, 35, 35, 0, PI);
    }
  }

  void chargerImageDos() {
    try {
      File f = dataFile("dos_carte.png");
      if (f.exists()) {
        imageDos = loadImage("dos_carte.png");
      } else {
        imageDos = creerImageDos();
      }
    } catch (Exception e) {
      imageDos = creerImageDos();
    }
  }

  PImage creerImageDos() {
    PGraphics pg = createGraphics(200, 150);
    pg.beginDraw();
    pg.background(200, 30, 50);

    pg.noStroke();
    for (int i = 0; i < 200; i += 20) {
      for (int j = 0; j < 150; j += 20) {
        if ((i / 20 + j / 20) % 2 == 0) {
          pg.fill(40, 60, 65);
        } else {
          pg.fill(25, 40, 65);
        }
        pg.rect(i, j, 20, 20);
      }
    }

    pg.fill(0, 210, 255);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(60);
    pg.text("?", 100, 75);

    pg.endDraw();
    return pg;
  }

  PImage[] getImages(String thematique, String pays, String sousTheme) {
    if (bibliothequeImages.containsKey(thematique)) {
      HashMap<String, HashMap<String, PImage[]>> themePays = bibliothequeImages.get(thematique);
      if (themePays.containsKey(pays)) {
        HashMap<String, PImage[]> sousTh = themePays.get(pays);
        if (sousTh.containsKey(sousTheme)) {
          return sousTh.get(sousTheme);
        }
      }
    }
    return creerImagesParDefaut();
  }

  // Récupération des hymnes
  SoundFile[] getHymnes(String pays) {
    println(" Recherche hymnes pour : " + pays);
    if (bibliothequeHymnes.containsKey(pays)) {
      SoundFile[] hymnes = bibliothequeHymnes.get(pays);
      int nbHymnes = 0;
      for (SoundFile h : hymnes) {
        if (h != null) nbHymnes++;
      }
      println(" " + nbHymnes + " hymnes trouvés pour " + pays);
      return hymnes;
    }
    println(" Aucun hymne trouvé pour : " + pays);
    return null;
  }

  PImage[] creerImagesParDefaut() {
    PImage[] images = new PImage[NB_IMAGES_MAX];
    for (int i = 0; i < NB_IMAGES_MAX; i++) {
      images[i] = creerImageProcedurale("DEFAUT", i);
    }
    return images;
  }
}
