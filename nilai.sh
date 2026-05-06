#!/bin/bash

# ==================================================
# PENILAIAN PRACTICE 1 & 2 (ABSOLUTE PATH)
# Folder dicari di $HOME/LatihanProses1 dan $HOME/LatihanProses2
# History dibaca dari user
# Masing-masing praktik skala 0-100
# ==================================================

HISTORY_FILE=~/.bash_history
if [ ! -f "$HISTORY_FILE" ]; then
    echo "❌ File history tidak ditemukan. Jalankan 'history -a' terlebih dahulu."
    exit 1
fi

pernah() {
    grep -q "$1" "$HISTORY_FILE"
}

# Path absolut folder latihan
DIR1="$HOME/LatihanProses1"
DIR2="$HOME/LatihanProses2"

echo "========== PENILAIAN PRACTICE 1 (Job Control & Sinyal) =========="

SKOR1=0

if [ -d "$DIR1" ]; then
    echo "✅ Folder ditemukan: $DIR1"
    ((SKOR1+=10))
else
    echo "❌ Folder tidak ada di $DIR1"
fi

if [ -f "$DIR1/loop.sh" ]; then
    echo "✅ loop.sh ditemukan"
    ((SKOR1+=10))
    if grep -q "while true" "$DIR1/loop.sh" && grep -q "sleep 2" "$DIR1/loop.sh"; then
        echo "✅ Isi loop.sh sesuai"
        ((SKOR1+=15))
    else
        echo "⚠️ Isi loop.sh tidak lengkap"
    fi
    if [ -x "$DIR1/loop.sh" ]; then
        echo "✅ loop.sh executable"
        ((SKOR1+=10))
    else
        echo "❌ loop.sh tidak executable"
    fi
else
    echo "❌ loop.sh tidak ditemukan"
fi

if pernah "./loop.sh &" || pernah "bash loop.sh &" || grep -q "loop.sh &" "$HISTORY_FILE"; then
    echo "✅ loop.sh dijalankan di background"
    ((SKOR1+=15))
else
    echo "❌ Tidak ada perintah background"
fi

if pernah "jobs"; then
    echo "✅ Perintah 'jobs' digunakan"
    ((SKOR1+=10))
else
    echo "❌ 'jobs' tidak ditemukan"
fi

if pernah "kill %1" || (pernah "kill [0-9]" && ! pernah "kill -9"); then
    echo "✅ Kill graceful (SIGTERM) digunakan"
    ((SKOR1+=20))
elif pernah "kill -9"; then
    echo "⚠️ Hanya SIGKILL"
    ((SKOR1+=10))
else
    echo "❌ Tidak ada kill"
fi

if pernah "ps aux | grep loop.sh"; then
    echo "✅ Verifikasi dengan ps"
    ((SKOR1+=10))
else
    echo "❌ Tidak ada verifikasi"
fi

[ $SKOR1 -gt 100 ] && SKOR1=100
echo "----------------------------------------"
echo "🎯 NILAI PRACTICE 1 = $SKOR1 / 100"
echo ""

echo "========== PENILAIAN PRACTICE 2 (Debugging SSH) =========="

SKOR2=0

if [ -d "$DIR2" ]; then
    echo "✅ Folder ditemukan: $DIR2"
    ((SKOR2+=10))
else
    echo "❌ Folder tidak ada di $DIR2"
fi

if [ -f "/etc/ssh/sshd_config.bak" ]; then
    echo "✅ File backup ditemukan"
    ((SKOR2+=10))
elif pernah "sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak"; then
    echo "✅ Perintah backup terdeteksi"
    ((SKOR2+=10))
else
    echo "❌ Tidak ada backup"
fi

if grep -q "^Port 2222" /etc/ssh/sshd_config 2>/dev/null; then
    echo "✅ Port 2222 aktif di konfigurasi"
    ((SKOR2+=10))
elif pernah "sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config"; then
    echo "✅ Perintah ubah port terdeteksi"
    ((SKOR2+=10))
else
    echo "❌ Tidak ada perubahan port"
fi

if pernah "sudo systemctl restart sshd"; then
    echo "✅ Restart sshd dilakukan"
    ((SKOR2+=10))
else
    echo "❌ Tidak ada restart"
fi

if pernah "systemctl status sshd" || pernah "sudo systemctl status sshd"; then
    echo "✅ Pengecekan status"
    ((SKOR2+=10))
else
    echo "❌ Tidak cek status"
fi

if pernah "journalctl -u sshd"; then
    echo "✅ journalctl digunakan"
    ((SKOR2+=20))
else
    echo "❌ Tidak menggunakan journalctl"
fi

if ! grep -q "^Port 2222" /etc/ssh/sshd_config 2>/dev/null; then
    echo "✅ Konfigurasi sudah diperbaiki (port 2222 tidak ada)"
    ((SKOR2+=20))
elif pernah "sed -i '/Port 2222/d' /etc/ssh/sshd_config"; then
    echo "✅ Perintah penghapusan port 2222 terdeteksi"
    ((SKOR2+=20))
else
    echo "⚠️ Port 2222 masih ada. Belum diperbaiki."
fi

if systemctl is-active sshd >/dev/null 2>&1; then
    echo "✅ Layanan sshd aktif sekarang"
    ((SKOR2+=10))
else
    echo "⚠️ Layanan sshd tidak aktif"
fi

[ $SKOR2 -gt 100 ] && SKOR2=100
echo "----------------------------------------"
echo "🎯 NILAI PRACTICE 2 = $SKOR2 / 100"

# RINGKASAN
echo ""
echo "=============================================="
echo "📊 RINGKASAN NILAI PRACTICE (ABSOLUTE)"
echo "   Practice 1 : $SKOR1 / 100"
echo "   Practice 2 : $SKOR2 / 100"
echo "=============================================="

grade() {
    if [ $1 -ge 81 ]; then echo "A (Sepuh)"
    elif [ $1 -ge 75 ]; then echo "B+ (Very Good)"
    elif [ $1 -ge 70 ]; then echo "B (Good)"
    elif [ $1 -ge 60 ]; then echo "C+ (Fairly Good)"
    elif [ $1 -ge 55 ]; then echo "C (Fair)"
    elif [ $1 -ge 41 ]; then echo "D (Poor)"
    else echo "E (Bro really...)"
    fi
}

echo "Grade Practice 1: $(grade $SKOR1)"
echo "Grade Practice 2: $(grade $SKOR2)"
echo "=============================================="
