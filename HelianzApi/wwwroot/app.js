/**
 * HELIANZ DENTAL TV QUEUE DISPLAY & EDUCATION SYSTEM
 * Full-featured TV Screen Web App with Split Screen Video Player, Chime + TTS
 */

// =============================================================================
// 1. STATE & CONFIGURATION
// =============================================================================

const DEFAULT_CONFIG = {
  clinicName: "D'SMILE DENTAL CARE",
  clinicBranch: "Klinik Utama",
  clinicAddress: "Pusat Layanan Kesehatan Gigi Terpadu",
  apiEndpoint: "/api/queue",
  clinicNum: 0,
  demoMode: false,
  voiceLang: "id-ID",
  voiceVolume: 90,
  voiceRate: 9,
  voiceTemplate: "Nomor antrian {ticket}, {patient}, silakan menuju ke {room}",
  privacyMask: true,
  marqueeText: "Selamat Datang di D'SMILE Dental Care • Harap perhatikan nomor antrian pada layar • Jaga kesehatan gigi dan gusi dengan kontrol rutin setiap 6 bulan • Fasilitas modern & dokter spesialis terpercaya • Terima kasih atas kunjungan Anda.",
  playlist: [
    {
      id: "v1",
      title: "Cara Menyikat Gigi yang Benar (Toothbrushing)",
      type: "youtube",
      url: "https://www.youtube.com/watch?v=xm9c5HAUBpY",
      ytId: "xm9c5HAUBpY"
    },
    {
      id: "v2",
      title: "Pentingnya Scaling Karang Gigi 6 Bulan Sekali",
      type: "youtube",
      url: "https://www.youtube.com/watch?v=kYv9Z8F9M6c",
      ytId: "kYv9Z8F9M6c"
    },
    {
      id: "v3",
      title: "Edukasi Perawatan Kawat Gigi (Orthodontic)",
      type: "youtube",
      url: "https://www.youtube.com/watch?v=t1nRM4X3y4M",
      ytId: "t1nRM4X3y4M"
    },
    {
      id: "v4",
      title: "Tips Menjaga Gigi Anak Bebas Karies",
      type: "youtube",
      url: "https://www.youtube.com/watch?v=J8n0j8QG7w4",
      ytId: "J8n0j8QG7w4"
    }
  ]
};

// Health tips for rotating banner
const DENTAL_TIPS = [
  {
    title: "Pemeriksaan Rutin Setiap 6 Bulan",
    desc: "Kunjungi dokter gigi minimal 6 bulan sekali untuk scaling karang gigi dan deteksi dini masalah gigi sebelum berlubang parah.",
    icon: `<svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="M12 16v-4M12 8h.01"></path></svg>`
  },
  {
    title: "Teknik Menyikat Gigi 2-2-2",
    desc: "Sikat gigi 2 kali sehari (pagi setelah sarapan & malam sebelum tidur), selama 2 menit penuh dengan pasta gigi berfluoride.",
    icon: `<svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>`
  },
  {
    title: "Gunakan Benang Gigi (Dental Floss)",
    desc: "Sikat gigi hanya membersihkan 60% permukaan gigi. Gunakan dental floss setiap malam untuk mengangkat plak di sela-sela gigi sempit.",
    icon: `<svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>`
  },
  {
    title: "Ganti Sikat Gigi Berkala",
    desc: "Ganti sikat gigi Anda setiap 3 bulan sekali atau lebih cepat jika bulu sikat sudah mulai mengembang / rusak.",
    icon: `<svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.24 12.24a6 6 0 0 0-8.49-8.49L5 10.5V19h8.5z"></path></svg>`
  }
];

// App State
let appConfig = loadConfig();
let audioUnlocked = false;
let audioEnabled = true;
let isVideoMuted = true;
let currentVideoIndex = 0;
let ytPlayer = null;
let ytApiReady = false;
let callQueue = [];
let isAnnouncing = false;
let lastAnnouncedCallId = null;
let currentTipIndex = 0;

// Demo Data State (Simulated Queue when offline/demo mode)
let demoState = {
  currentCalling: null,
  rooms: [],
  waitingList: []
};

// =============================================================================
// 2. CONFIGURATION & LOCALSTORAGE
// =============================================================================

function loadConfig() {
  try {
    const saved = localStorage.getItem("helianz_tv_config");
    if (saved) {
      return { ...DEFAULT_CONFIG, ...JSON.parse(saved) };
    }
  } catch (e) {
    console.warn("Could not load stored config, using defaults", e);
  }
  return { ...DEFAULT_CONFIG };
}

function saveConfig(cfg) {
  appConfig = { ...appConfig, ...cfg };
  try {
    localStorage.setItem("helianz_tv_config", JSON.stringify(appConfig));
  } catch (e) {
    console.error("Failed to save config", e);
  }
  applyConfigToUI();
}

function applyConfigToUI() {
  document.getElementById("clinicNameDisplay").textContent = appConfig.clinicName;
  document.getElementById("clinicBranchDisplay").textContent = appConfig.clinicBranch;
  document.getElementById("clinicAddressDisplay").textContent = appConfig.clinicAddress;
  document.getElementById("marqueeText").textContent = appConfig.marqueeText;
}

// =============================================================================
// 3. AUDIO ENGINE: SYNTHESIZER CHIME & TEXT-TO-SPEECH (TTS)
// =============================================================================

let audioCtx = null;

function getAudioContext() {
  if (!audioCtx) {
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) {
      audioCtx = new AudioContext();
    }
  }
  if (audioCtx && audioCtx.state === "suspended") {
    audioCtx.resume();
  }
  return audioCtx;
}

/**
 * Plays a high-clarity dual-tone chime (Ding-Dong) synthesized via Web Audio API
 */
function playChime() {
  return new Promise((resolve) => {
    if (!audioEnabled) {
      return resolve();
    }

    try {
      const ctx = getAudioContext();
      if (!ctx) return resolve();

      const now = ctx.currentTime;
      const vol = (appConfig.voiceVolume / 100) * 0.7;

      // Master Gain
      const masterGain = ctx.createGain();
      masterGain.gain.setValueAtTime(vol, now);
      masterGain.connect(ctx.destination);

      // Tone 1: D5 (587.33 Hz)
      const osc1 = ctx.createOscillator();
      const gain1 = ctx.createGain();
      osc1.type = "sine";
      osc1.frequency.setValueAtTime(587.33, now);
      gain1.gain.setValueAtTime(1, now);
      gain1.gain.exponentialRampToValueAtTime(0.001, now + 0.6);
      osc1.connect(gain1);
      gain1.connect(masterGain);

      // Tone 2: A5 (880 Hz) harmonic
      const osc2 = ctx.createOscillator();
      const gain2 = ctx.createGain();
      osc2.type = "sine";
      osc2.frequency.setValueAtTime(880, now);
      gain2.gain.setValueAtTime(0.4, now);
      gain2.gain.exponentialRampToValueAtTime(0.001, now + 0.5);
      osc2.connect(gain2);
      gain2.connect(masterGain);

      // Tone 3 (Dong): E5 (659.25 Hz) after 300ms
      const osc3 = ctx.createOscillator();
      const gain3 = ctx.createGain();
      osc3.type = "sine";
      osc3.frequency.setValueAtTime(659.25, now + 0.3);
      gain3.gain.setValueAtTime(0.001, now);
      gain3.gain.setValueAtTime(1, now + 0.3);
      gain3.gain.exponentialRampToValueAtTime(0.001, now + 1.2);
      osc3.connect(gain3);
      gain3.connect(masterGain);

      osc1.start(now);
      osc2.start(now);
      osc3.start(now + 0.3);

      osc1.stop(now + 0.7);
      osc2.stop(now + 0.7);
      osc3.stop(now + 1.3);

      setTimeout(resolve, 1100);
    } catch (e) {
      console.error("Chime error:", e);
      resolve();
    }
  });
}

/**
 * Text-to-Speech (TTS) Voice Announcement with SpeechSynthesis API
 */
function speakAnnouncement(text) {
  return new Promise((resolve) => {
    if (!audioEnabled || !("speechSynthesis" in window)) {
      return resolve();
    }

    try {
      window.speechSynthesis.cancel(); // Stop any pending speech

      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = appConfig.voiceLang || "id-ID";
      utterance.volume = Math.min(1, appConfig.voiceVolume / 100);
      utterance.rate = (appConfig.voiceRate || 9) / 10;
      utterance.pitch = 1.0;

      // Try selecting an Indonesian or chosen voice
      const voices = window.speechSynthesis.getVoices();
      if (voices.length > 0) {
        const langCode = appConfig.voiceLang.substring(0, 2);
        const matchVoice = voices.find(v => v.lang.startsWith(langCode)) || voices[0];
        if (matchVoice) {
          utterance.voice = matchVoice;
        }
      }

      const waveEl = document.getElementById("callingAudioWave");
      if (waveEl) waveEl.style.display = "flex";

      utterance.onend = () => {
        if (waveEl) waveEl.style.display = "none";
        resolve();
      };

      utterance.onerror = (err) => {
        console.warn("Speech error:", err);
        if (waveEl) waveEl.style.display = "none";
        resolve();
      };

      window.speechSynthesis.speak(utterance);
    } catch (e) {
      console.error("TTS error:", e);
      resolve();
    }
  });
}

/**
 * Format Ticket for Speech (e.g., 'A-012' -> 'A, nol satu dua' or 'A, twelve')
 */
function formatTicketForSpeech(ticket) {
  if (!ticket) return "";
  const parts = ticket.split("-");
  if (parts.length === 2) {
    const letter = parts[0];
    const num = parts[1];
    if (appConfig.voiceLang.startsWith("id")) {
      return `${letter}, ${num.replace(/^0+/, "") || "0"}`;
    }
    return `${letter}, ${num}`;
  }
  return ticket;
}

/**
 * Process Call Announcement Queue sequentially
 */
async function processCallQueue() {
  if (isAnnouncing || callQueue.length === 0) return;

  isAnnouncing = true;
  const item = callQueue.shift();

  try {
    // 1. Trigger hero card calling animation
    const heroCard = document.getElementById("heroCallingCard");
    heroCard.classList.add("active-call-animation");

    // 2. Play synthesized chime
    await playChime();

    // 3. Build announcement sentence
    const spokenTicket = formatTicketForSpeech(item.queueLabel);
    const patName = maskPatientName(item.patientName);
    const roomName = item.opName || "Ruang Operatori";
    const docName = item.provName || "Dokter Gigi";

    let speechText = appConfig.voiceTemplate || "Nomor antrian {ticket}, {patient}, silakan menuju ke {room}";
    speechText = speechText
      .replace("{ticket}", spokenTicket)
      .replace("{patient}", patName)
      .replace("{room}", roomName)
      .replace("{doctor}", docName);

    // 4. Speak voice
    await speakAnnouncement(speechText);

    setTimeout(() => {
      heroCard.classList.remove("active-call-animation");
    }, 1500);

  } catch (e) {
    console.error("Error in call queue:", e);
  } finally {
    isAnnouncing = false;
    if (callQueue.length > 0) {
      setTimeout(processCallQueue, 1000);
    }
  }
}

function queueAnnouncement(item) {
  callQueue.push(item);
  processCallQueue();
}

// =============================================================================
// 4. VIDEO PLAYER: YOUTUBE & HTML5 PLAYLIST MANAGER
// =============================================================================

function extractYouTubeId(url) {
  if (!url) return "";
  const match = url.match(/(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))([\w-]{11})/);
  return match ? match[1] : url;
}

// YouTube Iframe API callback
window.onYouTubeIframeAPIReady = function() {
  ytApiReady = true;
  initVideoPlayer();
};

function initVideoPlayer() {
  const currentVideo = appConfig.playlist[currentVideoIndex] || appConfig.playlist[0];
  if (!currentVideo) return;

  updateVideoHeader(currentVideo);
  renderPlaylistSelector();

  const ytContainer = document.getElementById("ytPlayerContainer");
  const html5Player = document.getElementById("html5VideoPlayer");

  if (currentVideo.type === "youtube" || currentVideo.url.includes("youtube.com") || currentVideo.url.includes("youtu.be")) {
    html5Player.style.display = "none";
    ytContainer.style.display = "block";

    const videoId = currentVideo.ytId || extractYouTubeId(currentVideo.url);

    if (ytPlayer && ytPlayer.loadVideoById) {
      ytPlayer.loadVideoById({ videoId });
      if (isVideoMuted) ytPlayer.mute();
      else ytPlayer.unMute();
      ytPlayer.playVideo();
    } else if (window.YT && window.YT.Player) {
      ytPlayer = new window.YT.Player("ytPlayer", {
        height: "100%",
        width: "100%",
        videoId: videoId,
        playerVars: {
          autoplay: 1,
          controls: 0,
          loop: 0,
          rel: 0,
          modestbranding: 1,
          playsinline: 1,
          mute: isVideoMuted ? 1 : 0
        },
        events: {
          onReady: onPlayerReady,
          onStateChange: onPlayerStateChange
        }
      });
    }
  } else {
    // HTML5 Video
    ytContainer.style.display = "none";
    html5Player.style.display = "block";
    html5Player.src = currentVideo.url;
    html5Player.muted = isVideoMuted;
    html5Player.play().catch(e => console.log("HTML5 Autoplay blocked", e));

    html5Player.onended = () => {
      nextVideo();
    };
  }
}

function onPlayerReady(event) {
  if (isVideoMuted) event.target.mute();
  else event.target.unMute();
  event.target.playVideo();
}

function onPlayerStateChange(event) {
  // YT.PlayerState.ENDED is 0
  if (event.data === 0) {
    nextVideo();
  }
}

function nextVideo() {
  if (!appConfig.playlist || appConfig.playlist.length === 0) return;
  currentVideoIndex = (currentVideoIndex + 1) % appConfig.playlist.length;
  loadCurrentVideo();
}

function prevVideo() {
  if (!appConfig.playlist || appConfig.playlist.length === 0) return;
  currentVideoIndex = (currentVideoIndex - 1 + appConfig.playlist.length) % appConfig.playlist.length;
  loadCurrentVideo();
}

function loadCurrentVideo() {
  const vid = appConfig.playlist[currentVideoIndex];
  if (!vid) return;

  updateVideoHeader(vid);
  renderPlaylistSelector();

  const ytContainer = document.getElementById("ytPlayerContainer");
  const html5Player = document.getElementById("html5VideoPlayer");

  if (vid.type === "youtube" || vid.url.includes("youtube.com") || vid.url.includes("youtu.be")) {
    html5Player.style.display = "none";
    html5Player.pause();
    ytContainer.style.display = "block";

    const videoId = vid.ytId || extractYouTubeId(vid.url);
    if (ytPlayer && ytPlayer.loadVideoById) {
      ytPlayer.loadVideoById({ videoId });
      if (isVideoMuted) ytPlayer.mute();
      else ytPlayer.unMute();
      ytPlayer.playVideo();
    }
  } else {
    ytContainer.style.display = "none";
    if (ytPlayer && ytPlayer.pauseVideo) ytPlayer.pauseVideo();
    html5Player.style.display = "block";
    html5Player.src = vid.url;
    html5Player.muted = isVideoMuted;
    html5Player.play().catch(e => console.log(e));
  }
}

function updateVideoHeader(vid) {
  document.getElementById("currentVideoTitle").textContent = vid.title;
  document.getElementById("videoIndexBadge").textContent = `Video ${currentVideoIndex + 1}/${appConfig.playlist.length}`;
}

function renderPlaylistSelector() {
  const container = document.getElementById("playlistThumbnails");
  if (!container) return;

  container.innerHTML = "";
  appConfig.playlist.forEach((vid, idx) => {
    const card = document.createElement("div");
    card.className = `playlist-item-card ${idx === currentVideoIndex ? "active" : ""}`;
    card.innerHTML = `
      <span>${idx + 1}.</span>
      <span>${vid.title}</span>
    `;
    card.onclick = () => {
      currentVideoIndex = idx;
      loadCurrentVideo();
    };
    container.appendChild(card);
  });
}

function toggleVideoSound() {
  isVideoMuted = !isVideoMuted;
  const btnText = document.getElementById("txtVidSound");
  const iconMute = document.getElementById("iconVidMute");

  if (isVideoMuted) {
    btnText.textContent = "Muted";
    if (ytPlayer && ytPlayer.mute) ytPlayer.mute();
    const html5Player = document.getElementById("html5VideoPlayer");
    if (html5Player) html5Player.muted = true;
  } else {
    btnText.textContent = "Suara Aktif";
    if (ytPlayer && ytPlayer.unMute) ytPlayer.unMute();
    const html5Player = document.getElementById("html5VideoPlayer");
    if (html5Player) html5Player.muted = false;
  }
}

// =============================================================================
// 5. QUEUE DATA RENDERING & API INTEGRATION
// =============================================================================

function maskPatientName(name) {
  if (!name) return "-";
  if (!appConfig.privacyMask) return name;

  const parts = name.trim().split(" ");
  if (parts.length === 1) {
    const word = parts[0];
    if (word.length <= 3) return word;
    return word.substring(0, 3) + "***";
  }

  // Keep first name, mask subsequent words: e.g. "Budi Santoso" -> "Budi S***"
  return parts.map((word, idx) => {
    if (idx === 0) return word;
    return word.charAt(0) + "***";
  }).join(" ");
}

/**
 * Render Hero Calling Card
 */
function renderHeroCalling(calling) {
  const heroTicket = document.getElementById("heroTicketNum");
  const heroPatient = document.getElementById("heroPatientName");
  const heroRoom = document.getElementById("heroRoomName");
  const heroDoctor = document.getElementById("heroDoctorName");

  if (calling && calling.queueLabel) {
    heroTicket.textContent = calling.queueLabel;
    heroPatient.textContent = maskPatientName(calling.patientName);
    heroRoom.textContent = calling.opName || "Ruang Operatori";
    heroDoctor.textContent = calling.provName || "Dokter Jaga";
  } else {
    heroTicket.textContent = "--";
    heroPatient.textContent = "Menunggu Panggilan";
    heroRoom.textContent = "Ruang Operatori";
    heroDoctor.textContent = "Dokter Jaga";
  }
}

/**
 * Render Doctor Rooms Matrix
 */
function renderRoomsGrid(rooms) {
  const grid = document.getElementById("roomsGrid");
  const badge = document.getElementById("roomCountBadge");
  if (!grid) return;

  if (!rooms || rooms.length === 0) {
    grid.innerHTML = `<div style="grid-column:span 2; text-align:center; color:var(--text-muted); padding:20px;">Tidak ada dokter praktek saat ini.</div>`;
    return;
  }

  badge.textContent = `${rooms.length} Ruangan`;
  grid.innerHTML = "";

  rooms.forEach(room => {
    const isServing = room.status === "Serving" && room.currentPatient;
    const card = document.createElement("div");
    card.className = `room-card ${isServing ? "is-serving" : ""}`;

    const statusClass = isServing ? "serving" : "available";
    const statusText = isServing ? "Sedang Melayani" : "Tersedia";
    const servingTicket = isServing ? room.currentPatient.queueLabel : "Siap";
    const servingClass = isServing ? "" : "empty";

    card.innerHTML = `
      <div class="room-card-header">
        <span class="room-name">${room.opName}</span>
        <span class="status-pill ${statusClass}">${statusText}</span>
      </div>
      <div class="room-doctor-name">${room.provName || "Dokter Gigi"}</div>
      <div class="room-ticket-serving">
        <span class="serving-label">Nomor Antrian:</span>
        <span class="serving-num ${servingClass}">${servingTicket}</span>
      </div>
    `;
    grid.appendChild(card);
  });
}

/**
 * Render Next In Line / Waiting List
 */
function renderWaitingList(list) {
  const container = document.getElementById("waitingListCards");
  const badge = document.getElementById("waitingCountBadge");
  if (!container) return;

  badge.textContent = `${list.length} Menunggu`;
  container.innerHTML = "";

  if (list.length === 0) {
    container.innerHTML = `<div style="grid-column:span 4; text-align:center; color:var(--text-muted); font-size:0.8rem; padding:8px;">Tidak ada antrian berikutnya</div>`;
    return;
  }

  // Show up to 4 upcoming patients
  const displayList = list.slice(0, 4);
  displayList.forEach(item => {
    const card = document.createElement("div");
    card.className = "waiting-mini-card";
    card.innerHTML = `
      <div class="waiting-mini-ticket">${item.queueLabel}</div>
      <div class="waiting-mini-patient">${maskPatientName(item.patientName)}</div>
      <div class="waiting-mini-room">${item.opName || "Poli"}</div>
    `;
    container.appendChild(card);
  });
}

/**
 * Fetch Live Queue State from Helianz API
 */
async function fetchQueueData() {
  const statusDot = document.getElementById("connectionStatus");
  const statusText = document.getElementById("connStatusText");

  try {
    const url = `${appConfig.apiEndpoint}/display?clinicNum=${appConfig.clinicNum || 0}`;
    const res = await fetch(url, { method: "GET", headers: { "Accept": "application/json" } });

    if (res.ok) {
      const data = await res.json();
      statusDot.className = "conn-status online";
      statusText.textContent = "Tersambung MT Server";

      // Populate Clinic Dropdown if clinics returned
      if (data.clinics && data.clinics.length > 0) {
        populateClinicDropdown(data.clinics, data.clinicNum);
      }
      if (data.clinicName) {
        document.getElementById("clinicNameDisplay").textContent = data.clinicName;
      }
      if (data.clinicAddress) {
        document.getElementById("clinicAddressDisplay").textContent = data.clinicAddress;
      }
      if (data.marqueeText) {
        document.getElementById("marqueeText").textContent = data.marqueeText;
      }

      // Render API Data
      renderHeroCalling(data.currentCalling);
      renderRoomsGrid(data.rooms);
      renderWaitingList(data.waitingList || []);

      // Check if new call triggered from server
      if (data.currentCalling && data.currentCalling.aptNum) {
        const callId = `${data.currentCalling.aptNum}-${data.currentCalling.lastCalledAt || ""}`;
        if (callId !== lastAnnouncedCallId && lastAnnouncedCallId !== null) {
          lastAnnouncedCallId = callId;
          queueAnnouncement(data.currentCalling);
        } else if (lastAnnouncedCallId === null) {
          lastAnnouncedCallId = callId;
        }
      }

      // Populate Caller Table if modal open
      renderCallerTable(data.waitingList || []);
      return;
    }
  } catch (err) {
    // API not reachable -> fallback to Demo Mode
    statusDot.className = "conn-status";
    statusText.textContent = appConfig.demoMode ? "Mode Simulasi" : "Offline";
  }

  // Fallback to local demo state only if explicitly enabled
  if (appConfig.demoMode) {
    renderHeroCalling(demoState.currentCalling);
    renderRoomsGrid(demoState.rooms);
    renderWaitingList(demoState.waitingList);
    renderCallerTable(demoState.waitingList);
  } else {
    renderHeroCalling(null);
    renderRoomsGrid([]);
    renderWaitingList([]);
    renderCallerTable([]);
  }
}

// =============================================================================
// 6. STAFF CALLER REMOTE CONTROLLER
// =============================================================================

function renderCallerTable(waitingList) {
  const tbody = document.getElementById("callerQueueTbody");
  const countBadge = document.getElementById("callerQueueCount");
  if (!tbody) return;

  countBadge.textContent = waitingList.length;
  tbody.innerHTML = "";

  if (waitingList.length === 0) {
    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--text-muted);">Tidak ada antrian menunggu</td></tr>`;
    return;
  }

  waitingList.forEach(item => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td><strong>${item.queueLabel}</strong></td>
      <td>${item.patientName}</td>
      <td>${item.opName || "Poli Gigi"}</td>
      <td>${item.minutesWaiting ? item.minutesWaiting + " mnt lalu" : "Baru Tiba"}</td>
      <td><span class="status-pill available">Menunggu</span></td>
      <td>
        <button class="btn-manual-call" style="padding:4px 10px; font-size:0.75rem;" onclick="callSpecificPatient(${item.aptNum})">
          Panggil
        </button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

window.callSpecificPatient = async function(aptNum) {
  const selectRoom = document.getElementById("callerRoomSelect");
  const opNum = parseInt(selectRoom.value, 10);
  const opName = selectRoom.options[selectRoom.selectedIndex].text.split("(")[0].trim();
  const doctorName = document.getElementById("callerDoctorInput").value;

  // Try API first
  try {
    const res = await fetch(`${appConfig.apiEndpoint}/call`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        aptNum: aptNum,
        opNum: opNum,
        clinicNum: appConfig.clinicNum
      })
    });
    if (res.ok) {
      const called = await res.json();
      queueAnnouncement(called);
      fetchQueueData();
      return;
    }
  } catch (e) {
    console.log("Call API fallback to demo", e);
  }

  // Demo fallback
  const idx = demoState.waitingList.findIndex(w => w.aptNum === aptNum);
  if (idx !== -1) {
    const item = demoState.waitingList[idx];
    demoState.waitingList.splice(idx, 1);
    demoState.currentCalling = {
      ...item,
      opNum: opNum,
      opName: opName,
      provName: doctorName,
      lastCalledAt: new Date().toISOString()
    };

    // Update room status
    const room = demoState.rooms.find(r => r.operatoryNum === opNum);
    if (room) {
      room.status = "Serving";
      room.provName = doctorName;
      room.currentPatient = { queueLabel: item.queueLabel, patientName: item.patientName };
    }

    queueAnnouncement(demoState.currentCalling);
    fetchQueueData();
  }
};

function setupCallerEvents() {
  const btnNext = document.getElementById("btnCallNext");
  const btnRecall = document.getElementById("btnRecallCurrent");
  const btnSeat = document.getElementById("btnMarkSeated");
  const btnDone = document.getElementById("btnMarkDone");
  const btnManual = document.getElementById("btnManualCall");

  // Call Next
  btnNext.onclick = () => {
    if (demoState.waitingList.length > 0) {
      const nextPat = demoState.waitingList[0];
      callSpecificPatient(nextPat.aptNum);
    } else {
      alert("Tidak ada pasien dalam daftar antrian menunggu.");
    }
  };

  // Recall / Repeat Call
  btnRecall.onclick = () => {
    if (demoState.currentCalling && demoState.currentCalling.queueLabel !== "--") {
      queueAnnouncement(demoState.currentCalling);
    } else {
      alert("Belum ada pasien yang dipanggil.");
    }
  };

  // Mark Seated
  btnSeat.onclick = () => {
    alert(`Pasien nomor ${demoState.currentCalling.queueLabel} tercatat telah masuk ke ruangan periksa.`);
  };

  // Mark Done
  btnDone.onclick = () => {
    const selectRoom = document.getElementById("callerRoomSelect");
    const opNum = parseInt(selectRoom.value, 10);
    const room = demoState.rooms.find(r => r.operatoryNum === opNum);
    if (room) {
      room.status = "Available";
      room.currentPatient = null;
    }
    fetchQueueData();
    alert(`Pemeriksaan di ruangan ${selectRoom.options[selectRoom.selectedIndex].text} telah selesai.`);
  };

  // Manual Walk-in Call
  btnManual.onclick = () => {
    const ticket = document.getElementById("manualTicketInput").value.trim().toUpperCase();
    const name = document.getElementById("manualNameInput").value.trim() || "Pasien Walk-in";
    const selectRoom = document.getElementById("callerRoomSelect");
    const opName = selectRoom.options[selectRoom.selectedIndex].text.split("(")[0].trim();
    const doctorName = document.getElementById("callerDoctorInput").value;

    if (!ticket) {
      alert("Harap masukkan nomor antrian (contoh: A-015)");
      return;
    }

    const item = {
      aptNum: Date.now(),
      patNum: 999,
      patientName: name,
      queueLabel: ticket,
      opName: opName,
      provName: doctorName,
      lastCalledAt: new Date().toISOString()
    };

    demoState.currentCalling = item;
    queueAnnouncement(item);
    fetchQueueData();

    document.getElementById("manualTicketInput").value = "";
    document.getElementById("manualNameInput").value = "";
  };
}

// =============================================================================
// 7. HEALTH TIPS INFOGRAPHIC CAROUSEL
// =============================================================================

function rotateHealthTips() {
  currentTipIndex = (currentTipIndex + 1) % DENTAL_TIPS.length;
  const tip = DENTAL_TIPS[currentTipIndex];

  const titleEl = document.getElementById("tipTitle");
  const descEl = document.getElementById("tipDesc");
  const iconEl = document.getElementById("tipIcon");
  const indicators = document.querySelectorAll("#tipsIndicators .indicator");

  if (titleEl && descEl && iconEl) {
    titleEl.textContent = tip.title;
    descEl.textContent = tip.desc;
    iconEl.innerHTML = tip.icon;

    indicators.forEach((ind, idx) => {
      if (idx === currentTipIndex) ind.classList.add("active");
      else ind.classList.remove("active");
    });
  }
}

// =============================================================================
// 8. SETTINGS MODAL CONTROLLER
// =============================================================================

function setupSettingsModal() {
  const modal = document.getElementById("settingsModal");
  const btnOpen = document.getElementById("btnOpenSettings");
  const btnClose = document.getElementById("btnCloseSettings");
  const btnSave = document.getElementById("btnSaveSettings");
  const btnReset = document.getElementById("btnResetSettings");
  const btnTestVoice = document.getElementById("btnTestVoice");
  const btnAddVideo = document.getElementById("btnAddVideo");

  btnOpen.onclick = () => {
    // Populate form with current config
    document.getElementById("cfgClinicName").value = appConfig.clinicName;
    document.getElementById("cfgClinicBranch").value = appConfig.clinicBranch;
    document.getElementById("cfgClinicAddress").value = appConfig.clinicAddress;
    document.getElementById("cfgApiEndpoint").value = appConfig.apiEndpoint;
    document.getElementById("cfgClinicNum").value = appConfig.clinicNum || 0;
    document.getElementById("cfgDemoMode").checked = appConfig.demoMode;
    document.getElementById("cfgVoiceLang").value = appConfig.voiceLang;
    document.getElementById("cfgVoiceVolume").value = appConfig.voiceVolume;
    document.getElementById("cfgVoiceRate").value = appConfig.voiceRate;
    document.getElementById("cfgVoiceTemplate").value = appConfig.voiceTemplate;
    document.getElementById("cfgPrivacyMask").checked = appConfig.privacyMask;
    document.getElementById("cfgMarqueeInput").value = appConfig.marqueeText;

    renderSettingsPlaylist();
    modal.style.display = "flex";
  };

  btnClose.onclick = () => { modal.style.display = "none"; };

  btnSave.onclick = () => {
    saveConfig({
      clinicName: document.getElementById("cfgClinicName").value.trim(),
      clinicBranch: document.getElementById("cfgClinicBranch").value.trim(),
      clinicAddress: document.getElementById("cfgClinicAddress").value.trim(),
      apiEndpoint: document.getElementById("cfgApiEndpoint").value.trim(),
      clinicNum: parseInt(document.getElementById("cfgClinicNum").value, 10) || 0,
      demoMode: document.getElementById("cfgDemoMode").checked,
      voiceLang: document.getElementById("cfgVoiceLang").value,
      voiceVolume: parseInt(document.getElementById("cfgVoiceVolume").value, 10),
      voiceRate: parseInt(document.getElementById("cfgVoiceRate").value, 10),
      voiceTemplate: document.getElementById("cfgVoiceTemplate").value.trim(),
      privacyMask: document.getElementById("cfgPrivacyMask").checked,
      marqueeText: document.getElementById("cfgMarqueeInput").value.trim()
    });
    modal.style.display = "none";
    fetchQueueData();
  };

  btnReset.onclick = () => {
    if (confirm("Reset seluruh pengaturan ke default?")) {
      saveConfig(DEFAULT_CONFIG);
      modal.style.display = "none";
    }
  };

  btnTestVoice.onclick = async () => {
    await playChime();
    speakAnnouncement("Nomor antrian A, nol dua belas, silakan menuju ke Poli Gigi 1");
  };

  btnAddVideo.onclick = () => {
    const title = document.getElementById("newVideoTitle").value.trim();
    const url = document.getElementById("newVideoUrl").value.trim();
    if (!title || !url) {
      alert("Harap masukkan judul dan URL video.");
      return;
    }

    const isYt = url.includes("youtube.com") || url.includes("youtu.be");
    const newVid = {
      id: "v_" + Date.now(),
      title: title,
      type: isYt ? "youtube" : "mp4",
      url: url,
      ytId: isYt ? extractYouTubeId(url) : ""
    };

    appConfig.playlist.push(newVid);
    saveConfig({ playlist: appConfig.playlist });
    renderSettingsPlaylist();
    renderPlaylistSelector();

    document.getElementById("newVideoTitle").value = "";
    document.getElementById("newVideoUrl").value = "";
  };
}

function renderSettingsPlaylist() {
  const container = document.getElementById("settingsPlaylistList");
  if (!container) return;

  container.innerHTML = "";
  appConfig.playlist.forEach((vid, idx) => {
    const item = document.createElement("div");
    item.className = "settings-playlist-item";
    item.innerHTML = `
      <span><strong>${idx + 1}.</strong> ${vid.title} (${vid.type.toUpperCase()})</span>
      <button class="btn-remove-vid" onclick="removePlaylistItem(${idx})">Hapus</button>
    `;
    container.appendChild(item);
  });
}

window.removePlaylistItem = function(index) {
  if (appConfig.playlist.length <= 1) {
    alert("Minimal harus ada 1 video dalam playlist.");
    return;
  }
  appConfig.playlist.splice(index, 1);
  saveConfig({ playlist: appConfig.playlist });
  renderSettingsPlaylist();
  renderPlaylistSelector();
  if (currentVideoIndex >= appConfig.playlist.length) {
    currentVideoIndex = 0;
  }
  loadCurrentVideo();
};

// =============================================================================
// 9. CLOCK & INITIALIZATION
// =============================================================================

function updateClock() {
  const now = new Date();
  const timeEl = document.getElementById("timeClock");
  const dateEl = document.getElementById("dateClock");

  const hours = String(now.getHours()).padStart(2, "0");
  const mins = String(now.getMinutes()).padStart(2, "0");
  const secs = String(now.getSeconds()).padStart(2, "0");
  if (timeEl) timeEl.textContent = `${hours}:${mins}:${secs}`;

  const days = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
  const months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
  if (dateEl) {
    dateEl.textContent = `${days[now.getDay()]}, ${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`;
  }
}

function setupHeaderControls() {
  // Audio unlock banner click
  const btnUnlock = document.getElementById("btnUnlockAudio");
  const banner = document.getElementById("audioUnlockBanner");

  const unlockAudio = () => {
    audioUnlocked = true;
    getAudioContext();
    if ("speechSynthesis" in window) {
      window.speechSynthesis.resume();
    }
    banner.style.display = "none";
  };

  btnUnlock.onclick = unlockAudio;
  document.body.addEventListener("click", () => {
    if (!audioUnlocked) unlockAudio();
  }, { once: true });

  // Fullscreen Button
  const btnFs = document.getElementById("btnFullscreen");
  btnFs.onclick = () => {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().catch(e => console.log(e));
    } else {
      document.exitFullscreen();
    }
  };

  // Audio Mute/Unmute Toggle
  const btnAudioToggle = document.getElementById("btnAudioToggle");
  const iconOn = document.getElementById("iconAudioOn");
  const iconOff = document.getElementById("iconAudioOff");

  btnAudioToggle.onclick = () => {
    audioEnabled = !audioEnabled;
    if (audioEnabled) {
      iconOn.style.display = "block";
      iconOff.style.display = "none";
    } else {
      iconOn.style.display = "none";
      iconOff.style.display = "block";
    }
  };

  // Video Sound Toggle
  document.getElementById("btnToggleVideoSound").onclick = toggleVideoSound;
  document.getElementById("btnNextVideo").onclick = nextVideo;
  document.getElementById("btnPrevVideo").onclick = prevVideo;
  document.getElementById("btnPlayPauseVideo").onclick = () => {
    if (ytPlayer && ytPlayer.getPlayerState) {
      const state = ytPlayer.getPlayerState();
      if (state === 1) ytPlayer.pauseVideo();
      else ytPlayer.playVideo();
    }
  };

  // Caller Remote Drawer Modal
  const callerModal = document.getElementById("callerModal");
  document.getElementById("btnOpenCaller").onclick = () => {
    callerModal.style.display = "flex";
  };
  document.getElementById("btnCloseCaller").onclick = () => {
    callerModal.style.display = "none";
  };
}

// =============================================================================
// 10. MAIN APP BOOTSTRAP
// =============================================================================

document.addEventListener("DOMContentLoaded", () => {
  applyConfigToUI();
  updateClock();
  setInterval(updateClock, 1000);

  setupHeaderControls();
  setupSettingsModal();
  setupCallerEvents();

  // Initial video player setup
  initVideoPlayer();

  // Initial data fetch & 3s polling
  fetchQueueData();
  setInterval(fetchQueueData, 3000);

  // Health tips rotation every 8 seconds
  setInterval(rotateHealthTips, 8000);

  // Auto-select clinic if URL has ?clinic=1 or ?clinicNum=1
  const urlParams = new URLSearchParams(window.location.search);
  const clinicParam = urlParams.get("clinic") || urlParams.get("clinicNum");
  if (clinicParam !== null) {
    appConfig.clinicNum = parseInt(clinicParam, 10);
  }

  // Auto-open caller panel if URL has ?caller=1 or ?role=caller
  if (urlParams.get("caller") === "1" || urlParams.get("role") === "caller") {
    document.getElementById("callerModal").style.display = "flex";
  }
});

function populateClinicDropdown(clinics, selectedNum) {
  const sel = document.getElementById("clinicSelectDropdown");
  if (!sel) return;

  if (sel.options.length > 1 && sel.options.length === clinics.length + 1) {
    if (sel.value != (selectedNum || 0)) sel.value = selectedNum || 0;
    return;
  }

  sel.innerHTML = `<option value="0">Semua Cabang / Pusat</option>`;
  clinics.forEach(c => {
    const opt = document.createElement("option");
    opt.value = c.clinicNum;
    opt.textContent = c.description || `Klinik ${c.clinicNum}`;
    sel.appendChild(opt);
  });
  sel.value = selectedNum || 0;

  sel.onchange = () => {
    appConfig.clinicNum = parseInt(sel.value, 10);
    saveConfig({ clinicNum: appConfig.clinicNum });
    fetchQueueData();
  };
}
