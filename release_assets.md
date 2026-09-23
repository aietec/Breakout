# Phase 7: Release Assets & Policy

## 1. Privacy Policy (Template)

**Effective Date:** September 23, 2026

**Introduction**
Welcome to Breakout. This privacy policy explains how we handle your data. We believe in data minimization and respect your privacy.

**Data Collection**
- **Gameplay Data:** We collect anonymous gameplay scores to populate global leaderboards via Firebase Cloud Firestore.
- **Monetization (AdMob UMP):** If you consent, Google Mobile Ads may collect device identifiers to serve relevant ads. You can revoke this via the app settings.
- **In-App Purchases:** Purchase data is handled directly by Apple (App Store) or Google (Play Store). We do not store or process your financial information.

**Data Sharing**
We do not sell your personal data. Anonymous scores and crash reports are strictly used for app improvement.

---

## 2. Store Listings (Fiche Descriptive)

### English (EN)
**Title:** Breakout: Retro Campaign
**Short Description:** The classic brick breaker reimagined with 72 levels and offline support!
**Full Description:**
Relive the golden age of arcade gaming with Breakout! Break bricks, collect high scores, and master the ball. 
- **Classic Mode:** True to the original 1976 rules.
- **Campaign Mode:** 72 handcrafted levels across 6 worlds, from moving bricks to indestructible bosses!
- **Play Anywhere:** 100% offline support.
- **Accessible:** High contrast modes, dynamic text sizing, and full RTL support.

### Français (FR)
**Titre :** Breakout : Campagne Rétro
**Description Courte :** Le casse-briques classique réinventé avec 72 niveaux jouables hors-ligne !
**Description Longue :**
Revivez l'âge d'or de l'arcade avec Breakout ! Brisez des briques, accumulez les scores et maîtrisez la balle.
- **Mode Classique :** Fidèle aux règles d'origine de 1976.
- **Mode Campagne :** 72 niveaux créés à la main à travers 6 mondes, incluant briques mobiles et boss indestructibles !
- **Jouez partout :** 100% fonctionnel hors-ligne.
- **Accessible :** Mode contraste renforcé, taille de texte dynamique et support complet des langues RTL.

---

## 3. Deployment Procedure

### Google Play Console (Android)
1. **Keystore:** We generated a `key.properties` file mapped in `android/app/build.gradle.kts`.
2. **Build:** Run `flutter build appbundle --release`.
3. **Upload:** Upload the `.aab` file from `build/app/outputs/bundle/release/` to the Google Play Console (Closed Testing track).
4. **Testers:** Add tester emails in the Play Console to distribute.

### Apple TestFlight (iOS)
1. **Xcode Config:** Open `ios/Runner.xcworkspace`. Set the Release schema. Ensure your Apple Developer Team is selected under "Signing & Capabilities".
2. **Build:** Run `flutter build ipa --release`.
3. **Upload:** Use the Transporter app or Xcode Organizer to push the `.ipa` to App Store Connect.
4. **TestFlight:** Add your internal/external testers in the TestFlight tab.
