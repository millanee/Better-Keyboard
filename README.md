# Better-Keyboard

**A Flutter-based mobile typing experiment designed for the course _Mobile Computing_ at the University of Copenhagen (UCPH).**

This project explores custom keyboard layouts for portrait and landscape orientations on mobile devices.  
It focuses on user performance, ergonomics, and typing accuracy by tracking typing speed, error rate, and time per character across two different keyboard prototypes.

## How It Works

1. From the **Start Screen**, select either *Prototype 1 (Landscape)* or *Prototype 2 (Portrait)*.  
2. Each prototype shows a sentence the user must retype exactly.  
3. Mistyped characters disable further typing until a backspace is pressed.  
4. After finishing the **practice phase**, a dialog appears prompting the **actual test**.  
5. Once the final test is done, a results dialog displays performance metrics and returns to the start screen.

---

## Technical Highlights

- Written entirely in **Dart + Flutter**  
- Fully custom keyboards (no native input fields used)  
- Real-time performance tracking  
- Orientation-aware layouts (landscape/portrait)  
- No external dependencies beyond `flutter/material.dart`

---

## Author & Course

Developed as part of the **Mobile Computing** course  
at the **Department of Computer Science, University of Copenhagen (DIKU)**.

*Course topic:* Human–Computer Interaction on mobile devices, focusing on typing ergonomics, performance measurement, and interface design.

---

## Getting Started

**Run locally:**
```bash
flutter pub get
flutter run
