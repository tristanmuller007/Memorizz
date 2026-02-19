class PageEasterEgg {

  Parametres reglages;

  String nomTheme = "ENFER";
  String descriptionFR = "Bienvenue en Enfer...\nSurvivez au chaos\nsi vous le pouvez";
  String descriptionEN = "Welcome to hell...\nSurvive the chaos\nif you can";

  float angle = 0;
  boolean retournee = false;
  float cW = 300;
  float cH = 400;

  float[] px = new float[50];
  float[] py = new float[50];
  float[] ps = new float[50];
  
  float[] flameX = new float[20];
  float[] flameY = new float[20];
  float[] flameSize = new float[20];
  float[] flameSpeed = new float[20];

  PageEasterEgg(Parametres r) {
    this.reglages = r;
    
    for (int i = 0; i < 50; i++) {
      px[i] = random(width);
      py[i] = random(height);
      ps[i] = random(5, 25);
    }

    for (int i = 0; i < 20; i++) {
      flameX[i] = random(width);
      flameY[i] = height + random(50);
      flameSize[i] = random(30, 80);
      flameSpeed[i] = random(1, 3);
    }
  }

  void reinitialiserCarte() {
    retournee = false;
    angle = 0;
  }

  void afficher(boolean anglais) {
    background(reglages.modeSombre ? color(10, 0, 0) : color(240, 200, 200));
    dessinerFondEnfer();

    pushMatrix();
    translate(0, 0, 1);
    
    float pulse = 1 + sin(frameCount * 0.05) * 0.1;

    for (int i = 8; i > 0; i--) {
      fill(255, 0, 0, 20 - i * 2);
      textSize((40 + i * 3) * pulse);
      textAlign(CENTER, TOP);
      text(anglais ? "HELL MODE" : "MODE ENFER", width / 2, 80);
    }

    fill(255, 50, 50);
    textSize(40 * pulse);
    text(anglais ? "HELL MODE" : "MODE ENFER", width / 2, 80);
    popMatrix();

    dessinerBoutonRetour(anglais);
    dessinerCarte(width / 2, height / 2, anglais);
    dessinerDescription(width / 2, height / 2 + cH / 2 + 40, anglais);
    dessinerAvertissement(anglais);
  }

  void dessinerBoutonRetour(boolean anglais) {
    float x = 70, y = 70, diametre = 60;
    boolean survol = dist(mouseX, mouseY, x, y) < diametre / 2;

    pushMatrix();
    translate(x, y);
    if (survol) scale(1.1);

    noStroke();
    fill(255, 0, 0, survol ? 80 : 30);
    ellipse(0, 0, diametre + 15, diametre + 15);

    fill(reglages.modeSombre ? color(15, 0, 0) : color(255, 200, 200));
    stroke(255, 50, 50);
    strokeWeight(3);
    ellipse(0, 0, diametre, diametre);

    stroke(255, 200, 200);
    strokeWeight(2);
    line(5, 0, -5, 0);
    line(-5, 0, 0, -5);
    line(-5, 0, 0, 5);

    fill(255, 200, 200);
    textAlign(CENTER, TOP);
    textSize(12);
    text(anglais ? "ESCAPE" : "FUIR", 0, diametre / 2 + 8);
    popMatrix();
  }

 void dessinerCarte(float x, float y, boolean anglais) {
    pushMatrix();//Enregistre la position actuelle de mon repère (le point 0,0)
    translate(x, y);

    float cible = retournee ? PI : 0;
    angle = lerp(angle, cible, 0.1);
    rotateY(angle);//mettre le texte à l'endroit

    rectMode(CENTER);
    noStroke();
    for (int i = 10; i > 0; i--) {
      fill(255, 0, 0, 15 - i);
      rect(0, 0, cW + i * 4, cH + i * 4, 20);
    }

    stroke(255, 0, 0);
    strokeWeight(4);

    if (angle < HALF_PI) {
      fill(reglages.modeSombre ? color(20, 0, 0) : color(255, 220, 220));
      rect(0, 0, cW, cH, 15);
      stroke(255, 0, 0, 150);
      noFill();
      rect(0, 0, cW - 20, cH - 20, 10);

      pushMatrix();
      translate(0, -50, 1);
      stroke(255, 50, 50, 200);
      strokeWeight(3);
      ellipse(0, 0, 120, 120);
      beginShape();
      for (int i = 0; i < 5; i++) {
        float a = i * TWO_PI * 2 / 5 - HALF_PI;
        vertex(cos(a) * 50, sin(a) * 50);
      }
      endShape(CLOSE);
      popMatrix();

      pushMatrix();//Enregistre la position actuelle de mon repère (le point 0,0)
      translate(0, 60, 1);
      fill(200, 50, 50);
      textAlign(CENTER, CENTER);
      String texteTheme = anglais ? "HELL" : "ENFER";
      float espacementLettre = 45;
      float startY = -(texteTheme.length() * espacementLettre) / 2 + espacementLettre / 2;

      for (int i = 0; i < texteTheme.length(); i++) {
        pushMatrix();
        translate(0, startY + i * espacementLettre);
        float shake = sin(frameCount * 0.2 + i) * 2;
        translate(shake, 0);
        rotate(radians(random(-5, 5)));
        textSize(50);
        text(texteTheme.charAt(i), 0, 0);
        popMatrix();// Reviens à la dernière position que j'ai enregistrée.
      }
      popMatrix();
    } else {

      pushMatrix();//Enregistre la position actuelle de mon repère (le point 0,0)
      rotateY(PI); // On pivote de 180° pour remettre le contenu face à nous
      
      fill(150, 0, 0);
      rect(0, 0, cW, cH, 15);
      fill(255, 200, 200);
      textSize(28);
      textAlign(CENTER, CENTER);
      text(nomTheme.toUpperCase(), 0, -20);
      fill(255, 150, 150);
      textSize(18);
      text(anglais ? "64 CARDS" : "64 CARTES", 0, 20);
      text("FRANCIS NGANNOU", 0, 45);
      
      popMatrix();
    }
    popMatrix();
    rectMode(CORNER);
  }
  void dessinerDescription(float x, float y, boolean anglais) {
    if (angle < HALF_PI) {
      pushMatrix();
      translate(0, 0, 1);
      float xCarte = width / 2;
      float yCarte = height / 2;
      boolean survol = (mouseX > xCarte - cW / 2 && mouseX < xCarte + cW / 2 &&
                        mouseY > yCarte - cH / 2 && mouseY < yCarte + cH / 2);

      if (survol) {
        fill(255, 0, 0, 40);
        noStroke();
        rectMode(CENTER);
        rect(x, y + 25, 320, 90, 10);
        rectMode(CORNER);
        fill(255, 100, 100);
      } else {
        fill(200, 80, 80);
      }

      textAlign(CENTER, TOP);
      textSize(16);
      text(anglais ? descriptionEN : descriptionFR, x, y);
      popMatrix();
    }
  }

  void dessinerAvertissement(boolean anglais) {
    pushMatrix();
    translate(0, 0, 1);
    float pulse = 0.8 + sin(frameCount * 0.1) * 0.2;
    fill(255, 0, 0, 150 * pulse);
    textAlign(CENTER, BOTTOM);
    textSize(14);
    text(anglais ? "Cards shuffle every 5 seconds" : "Cartes mélangées toutes les 5 secondes", width / 2, height - 50);
    popMatrix();
  }

  String detecterChoixTheme(int mx, int my) {
    float x = width / 2;
    float y = height / 2;
    if (mx > x - cW / 2 && mx < x + cW / 2 &&
        my > y - cH / 2 && my < y + cH / 2) {
      retournee = true;
      return "ENFER";
    }
    return "";
  }

  void dessinerFondEnfer() {
    for (int i = 0; i < 50; i++) {
      fill(255, random(0, 100), 0, 40);
      noStroke();
      rect(px[i], py[i], ps[i], ps[i]);
      py[i] -= 0.8;
      if (py[i] < 0) py[i] = height;
    }

    for (int i = 0; i < 20; i++) {
      for (int j = 3; j > 0; j--) {
        if (j == 3) fill(255, 100, 0, 60);
        else if (j == 2) fill(255, 50, 0, 40);
        else fill(255, 0, 0, 20);
        noStroke();
        ellipse(flameX[i], flameY[i], flameSize[i] * (j * 0.4), flameSize[i] * (j * 0.6));
      }
      flameY[i] -= flameSpeed[i];
      flameX[i] += sin(frameCount * 0.05 + i) * 0.5;
      if (flameY[i] < -50) {
        flameY[i] = height + random(50);
        flameX[i] = random(width);
      }
    }
  }

  boolean clicSurRetour(int mx, int my) {
    return (dist(mx, my, 70, 70) < 35);
  }
}
