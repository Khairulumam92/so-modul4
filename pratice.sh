#!/bin/bash

# ================================================
# PENILAIAN PRACTICE 1 & 2 (SKALA 0-100 MASING-MASING)
# ================================================

HISTORY_FILE=~/.bash_history
if [ ! -f "$HISTORY_FILE" ]; then
    echo "❌ File history tidak ditemukan. Jalankan 'history -a' terlebih dahulu."
    exit 1
fi

pernah() {
    grep -q "$1" "$HISTORY_FILE"
}

echo "========== PENILAIAN PRACTICE 1 (Job Control & Sinyal) =========="

SKOR1=0

# 1. Folder LatihanProses1
if [ -d "LatihanProses1" ]; then
    echo "✅ Folder LatihanProses1 ditemukan"
    ((SKOR1+=10))
else
    echo "❌ Folder LatihanProses1 tidak ada"
fi

# 2. File loop.sh
if [ -f "LatihanProses1/loop.sh" ]; then
    echo "✅ File loop.sh ditemukan"
    ((SKOR1+=10))
    if grep -q "while true" LatihanProses1/loop.sh && grep -q "sleep 2" LatihanProses1/loop.sh; then
        echo "✅ Isi loop.sh sesuai"
        ((SKOR1+=15))
    else
        echo "⚠️ Isi loop.sh tidak lengkap"
    fi
    if [ -x "LatihanProses1/loop.sh" ]; then
        echo "✅ loop.sh executable"
        ((SKOR1+=10))
    else
        echo "❌ loop.sh tidak executable"
    fi
else
    echo "❌ loop.sh tidak ditemukan"
fi

# 3. Menjalankan di background
if pernah "./loop.sh &" || pernah "bash loop.sh &" || grep -q "loop.sh &" "$HISTORY_FILE"; then
    echo "✅ loop.sh dijalankan di background"
    ((SKOR1+=15))
else
    echo "❌ Tidak ada perintah background"
fi

# 4. Pernah pakai jobs?
if pernah "jobs"; then
    echo "✅ Perintah 'jobs' digunakan"
    ((SKOR1+=10))
else
    echo "❌ 'jobs' tidak ditemukan"
fi

# 5. Kill graceful (SIGTERM)
if pernah "kill %1" || (pernah "kill [0-9]" && ! pernah "kill -9"); then
    echo "✅ Kill graceful (SIGTERM) digunakan"
    ((SKOR1+=20))
elif pernah "kill -9"; then
    echo "⚠️ Hanya menggunakan SIGKILL (-9), tidak graceful"
    ((SKOR1+=10))
else
    echo "❌ Tidak ada perintah kill"
fi

# 6. Verifikasi dengan ps
if pernah "ps aux | grep loop.sh"; then
    echo "✅ Verifikasi dengan ps"
    ((SKOR1+=10))
else
    echo "❌ Tidak ada verifikasi"
fi

if [ $SKOR1 -gt 100 ]; then SKOR1=100; fi
echo "----------------------------------------"
echo "🎯 NILAI PRACTICE 1 = $SKOR1 / 100"
echo ""

# ==================== PRACTICE 2 ====================
echo "========== PENILAIAN PRACTICE 2 (Debugging SSH) =========="

SKOR2=0

# 1. Folder LatihanProses2
if [ -d "LatihanProses2" ]; then
    echo "✅ Folder LatihanProses2 ditemukan"
    ((SKOR2+=10))
else
    echo "❌ Folder LatihanProses2 tidak ada"
fi

# 2. Backup konfigurasi
if [ -f "/etc/ssh/sshd_config.bak" ]; then
    echo "✅ File backup ditemukan"
    ((SKOR2+=10))
elif pernah "sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak"; then
    echo "✅ Perintah backup terdeteksi"
    ((SKOR2+=10))
else
    echo "❌ Tidak ada backup"
fi

# 3. Ubah port ke 2222
if grep -q "^Port 2222" /etc/ssh/sshd_config 2>/dev/null; then
    echo "✅ Port 2222 aktif di konfigurasi"
    ((SKOR2+=10))
elif pernah "sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config"; then
    echo "✅ Perintah ubah port terdeteksi"
    ((SKOR2+=10))
else
    echo "❌ Tidak ada perubahan port"
fi

# 4. Restart sshd
if pernah "sudo systemctl restart sshd"; then
    echo "✅ Restart sshd dilakukan"
    ((SKOR2+=10))
else
    echo "❌ Tidak ada restart"
fi

# 5. Cek status
if pernah "systemctl status sshd" || pernah "sudo systemctl status sshd"; then
    echo "✅ Pengecekan status"
    ((SKOR2+=10))
else
    echo "❌ Tidak cek status"
fi

# 6. Melihat log dengan journalctl
if pernah "journalctl -u sshd"; then
    echo "✅ journalctl digunakan"
    ((SKOR2+=20))
else
    echo "❌ Tidak menggunakan journalctl"
fi

# 7. Perbaikan konfigurasi
if ! grep -q "^Port 2222" /etc/ssh/sshd_config 2>/dev/null; then
    echo "✅ Konfigurasi sudah diperbaiki (port 2222 tidak ada)"
    ((SKOR2+=20))
elif pernah "sed -i '/Port 2222/d' /etc/ssh/sshd_config"; then
    echo "✅ Perintah penghapusan port 2222 terdeteksi"
    ((SKOR2+=20))
else
    echo "⚠️ Port 2222 masih ada. Belum diperbaiki."
fi

# 8. Layanan sshd aktif
if systemctl is-active sshd >/dev/null 2>&1; then
    echo "✅ Layanan sshd aktif sekarang"
    ((SKOR2+=10))
else
    echo "⚠️ Layanan sshd tidak aktif"
fi

if [ $SKOR2 -gt 100 ]; then SKOR2=100; fi
echo "----------------------------------------"
echo "🎯 NILAI PRACTICE 2 = $SKOR2 / 100"

# ==================== KESIMPULAN ====================
echo ""
echo "=============================================="
echo "📊 RINGKASAN NILAI PRACTICE"
echo "   Practice 1 (Job Control) : $SKOR1 / 100"
echo "   Practice 2 (Debug SSH)   : $SKOR2 / 100"
echo "=============================================="

grade() {
    local nilai=$1
    if [ $nilai -ge 81 ]; then echo "A (Sepuh)"
    elif [ $nilai -ge 75 ]; then echo "B+ (Very Good)"
    elif [ $nilai -ge 70 ]; then echo "B (Good)"
    elif [ $nilai -ge 60 ]; then echo "C+ (Fairly Good)"
    elif [ $nilai -ge 55 ]; then echo "C (Fair)"
    elif [ $nilai -ge 41 ]; then echo "D (Poor)"
    else echo "E (Bro really...)"
    fi
}

echo "Grade Practice 1: $(grade $SKOR1)"
echo "Grade Practice 2: $(grade $SKOR2)"
echo "=============================================="