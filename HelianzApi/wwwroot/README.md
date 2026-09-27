# Helianz Dental TV Queue Display & Patient Education System

A modern, high-definition Patient Queue Display system designed specifically for Dental Clinics and Healthcare Waiting Rooms, optimized for 1080p and 4K Big TV Screens, Smart TVs, Android TV boxes, and PC browsers.

---

## Key Features

1. **Split-Screen Layout (16:9 Widescreen)**:
   - **Left Screen**:
     - **Now Serving / Sedang Dipanggil (Hero Card)**: Large glowing ticket badge, patient name (with privacy mask option), destination operatory room, doctor name, and real-time audio waveform visualizer.
     - **Doctor Rooms Matrix (Poliklinik Status)**: Status cards for all active operatories/rooms and current patient tickets.
     - **Upcoming Waiting List (Antrian Berikutnya)**: Next 4 in-line patient tickets.
   - **Right Screen**:
     - **Educational Video Player**: Supports YouTube playlists & direct MP4 video files with autoplay, loop, playlist quick navigation, and mute/unmute toggle.
     - **Dental Health Tips Carousel**: Rotating dental hygiene facts and tips with automatic sliding cards.
   - **Bottom Ticker / Marquee**:
     - High-visibility running announcement text for clinic news, operating hours, and promotional info.

2. **Smart Audio & Voice Calling (Synthesizer Chime + Text-to-Speech)**:
   - Dual-tone harmonic chime synthesized in pure Web Audio API (no external MP3 required).
   - Multilingual Text-to-Speech (Indonesian `id-ID` and English `en-US`) announcing: *"Nomor antrian A-012, Tn. Budi, silakan menuju ke Poli Gigi 1"*.
   - Sequential Audio Queueing: Prevents overlapping voice calls when multiple patients are called rapidly.
   - Smart TV Autoplay Unlock: Built-in banner that unlocks audio in compliance with modern browser autoplay policies.

3. **Staff Remote Calling Console**:
   - Built-in remote caller modal accessible via the **"Petugas"** button or by opening `index.html?role=caller` / `index.html?caller=1`.
   - Allows nurses/doctors to click **"Panggil Berikutnya"**, **"Panggil Ulang (Recall)"**, **"Pasien Masuk (Seated)"**, **"Selesai (Dismissed)"**, or call walk-in tickets manually.

4. **Settings & Customization Modal**:
   - Customizable Clinic Name, Branch Name, Address, and API endpoint.
   - Playlist Manager: Add, remove, and reorder YouTube URLs or MP4 video links.
   - Voice Settings: Voice language, volume, speech speed rate, announcement template, and patient privacy mask toggle (`Budi S***`).
   - Demo / Simulation Mode: Seamlessly runs with simulated queue data if the API server is offline.

---

## How to Run & Deploy

### Option 1: Direct Web API Hosting (.NET 10)
Run the `HelianzApi` server:
```powershell
dotnet run --project d:\Project\Dental\Helianz\HelianzApi\HelianzApi.csproj
```
Open in any browser (TV or PC):
- **TV Display**: `http://<SERVER-IP>:5000/` or `http://<SERVER-IP>:5000/index.html`
- **Staff Calling Panel**: `http://<SERVER-IP>:5000/?role=caller`

### Option 2: Standalone Static File / Smart TV Browser
Simply open the `index.html` file located at:
`d:\Project\Dental\Helianz\QueueDisplay\index.html` in Chrome, Edge, Android TV Browser, or any static HTTP web server (e.g. `npx serve`, IIS, Nginx, or Live Server).

---

## API Endpoints Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/queue/display?clinicNum={id}` | Returns current calling ticket, active doctor rooms, and waiting list |
| `POST` | `/api/queue/call` | Triggers patient call with `{ aptNum, opNum, provNum }` |
| `POST` | `/api/queue/arrive/{aptNum}` | Records patient arrival in waiting room |
| `POST` | `/api/queue/seat/{aptNum}` | Marks patient seated in operatory chair |
| `POST` | `/api/queue/dismiss/{aptNum}` | Marks appointment completed / dismissed |
| `GET` | `/api/queue/playlist` | Returns default educational video playlist |
