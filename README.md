# Breakout - Flutter & Flame Game

Un clone moderne et complet du célèbre jeu d'arcade **Breakout** (1976), entièrement développé avec **Flutter** et le moteur de jeu **Flame**. Le jeu est conçu pour être 100 % jouable hors ligne.

## 🎮 Modes de Jeu

Le jeu intègre deux expériences distinctes :

### 1. Mode Campagne
Une aventure progressive avec sauvegarde locale (via `SharedPreferences`).
- **6 Mondes / 72 Niveaux** aux grilles variées.
- Système de score et de complétion (1 à 3 étoiles par niveau).
- Équilibrage progressif de la difficulté : les premiers mondes sont accessibles (balle plus lente, raquette large), tandis que les mondes supérieurs requièrent des réflexes acérés.

### 2. Mode Classique
Une restitution fidèle et authentique du gameplay arcade originel :
- **Règles historiques** : 8 rangées de 14 briques rapportant 1, 3, 5 et 7 points (soit 448 points par tableau). Maximum de 2 écrans.
- **Mécaniques d'époque** : Accélération stricte aux seuils de 4 briques, 12 briques, ou au premier contact orange/rouge. Rétrécissement de la raquette de 50 % dès le premier contact de la balle avec le plafond. 
- **Rebonds sectorisés** : La raquette est divisée en 4 zones de rebonds (angles de plus en plus prononcés vers les bords).

## 🛠️ Prérequis et Installation

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installé sur votre machine.

```bash
# 1. Cloner le projet
git clone https://github.com/aietec/Breakout.git
cd Breakout

# 2. Installer les dépendances
flutter pub get

# 3. Lancer le jeu (sur simulateur, navigateur ou appareil physique)
flutter run

# 4. Exécuter les tests unitaires et d'intégration
flutter test
```

## 🏗️ Architecture

- Le jeu exploite **Flame** pour la boucle de rendu et la physique via `FlameGame` et `HasCollisionDetection`.
- L'interface utilisateur, le HUD, les menus, et le système de sauvegarde sont développés avec des widgets **Flutter natifs**.
- La progression est gérée de manière asynchrone et persistant localement hors réseau.
