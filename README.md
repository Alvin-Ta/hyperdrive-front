<div align="center">

# 🏒 Hyperdrive

**A real-time NHL media app built for fans who want more than just scores.**

*Swift • Render • Node.js*

</div>

---

## Overview

Hyperdrive is an iOS app that pulls real-time NHL data to give fans a deeper view at every game. From live play-by-play to detailed player stats and head-to-head matchups, Hyperdrive surfaces the information that matters — fast.

---

## Screenshots

| Schedule | Past Results | Live Play-by-Play |
|----------|-------------|--------------|
| ![image](https://github.com/user-attachments/assets/fc29f7bb-33b8-40ca-ace7-b74b34a7304f) | ![Results](https://github.com/user-attachments/assets/8b71d3bd-a80d-4a46-82ec-15b5c65c8cd7) | ![Plays](https://github.com/user-attachments/assets/5d124b2c-b814-4cf2-b096-49c1dd6fdfbe) |

| Game Preview | Player Stats |
|-------------|--------------|
| ![Preview](https://github.com/user-attachments/assets/19051f70-d2c3-4633-8029-dd42c6c801b9) | ![Stats](https://github.com/user-attachments/assets/7dbb3c8b-2bcf-4a8b-a367-59a64d87bcbc) |

---

## Features

- 📅 **Daily Schedule** — Browse upcoming games by date with a scrollable calendar picker
- ✅ **Past Results** — View final scores from completed games at a glance
- 🔴 **Live Play-by-Play** — Detailed live moments that include goal scorers, assists, shots on goal, face-off wins and more!
- 🆚 **Game Previews** — View Head-to-head records, team standings, and player rosters before puck drop
- 📊 **Player Insights** — Analyze Season stats, career stats, and recent game-by-game performance with matchup filtering

---

## Architecture

Hyperdrive is built with a clean client/server separation:

- **iOS Client (Swift/SwiftUI)** — Built using the MVVM architecture pattern to keep views lightweight and business logic testable. Polling is used to continuously refresh live game data without requiring a persistent connection.
- **Node.js Backend — A dedicated server processes the unofficial NHL RESTful API and exposes clean, structured endpoints for the client to consume. This layer handles data transformation, filtering, and response shaping so the client stays lean. See [**hyperdrive-server**](https://github.com/Alvin-Ta/hyperdrive-backend) for the backend repo.
- **Deployed on Render** — The backend is hosted on Render for reliable uptime during live game windows.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| iOS Client | Swift, SwiftUI |
| Architecture | MVVM |
| Backend | Node.js |
| Deployment | Render |
| Data Source | [Unofficial NHL REST API](https://github.com/Zmalski/NHL-API-Reference) |

---

## Roadmap

- [ ] Push notifications for goal alerts
- [ ] AI integration for probable picks on each game
- [ ] Favourite teams & players
- [ ] App Store release
- [ ] Optimization of searching players

---

<div align="center">

Built by [Alvin Ta](https://github.com/Alvin-Ta) • Open to feedback and contributions

</div>
