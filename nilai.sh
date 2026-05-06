#!/bin/bash

# ==================================================
# PENILAIAN LENGKAP: EXERCISE 1-5 + PRACTICE 1-2
# Case-insensitive untuk folder
# Path absolut di $HOME
# ==================================================

HISTORY_FILE=~/.bash_history
if [ ! -f "$HISTORY_FILE" ]; then
    echo "❌ File history tidak ditemukan. Jalankan 'history -a' terlebih dahulu."
    exit 1
fi

pernah() {
    grep -q "$1" "$HISTORY_FILE"
}

# Fungsi mencari folder case-insensitive di $HOME
cari_folder_case_insensitive() {
    local nama=$1
    find "$HOME" -maxdepth 1 -type d -iname "$nama" | head -1
}

# ==================== EXERCISE 1-5 ====================
echo "=============================================="
echo "        PENILAIAN EXERCISE (1-5)"
echo "=============================================="

NILAI_EX1=0; NILAI_EX2=0; NILAI_EX3=0; NILAI_EX4=0; NILAI_EX5=0

echo -n "Exercise 1 (ping lifecycle): "
if pernah "ping -c 5 google.com"; then
    if pernah "ps aux | grep ping"; then
        echo "✅ 20"
        NILAI_EX1=20
    else
        echo "⚠️ 10"
        NILAI_EX1=10
    fi
else
    echo "❌ 0"
fi

echo -n "Exercise 2 (zombie/orphan): "
if pernah "ps aux | grep Z" || pernah "ps aux | grep defunct"; then
    echo "✅ 20"
    NILAI_EX2=20
elif ps aux | grep -q " Z "; then
    echo "⚠️ 10"
    NILAI_EX2=10
else
    echo "❌ 0"
fi

echo -n "Exercise 3 (top per-core): "
if pernah "top"; then
    echo "✅ 20"
    NILAI_EX3=20
else
    echo "❌ 0"
fi

echo -n "Exercise 4 (job control): "
SKOR4=0
if pernah "sleep 30 &"; then ((SKOR4+=5)); fi
if pernah "jobs"; then ((SKOR4+=5)); fi
if pernah "fg %"; then ((SKOR4+=5)); fi
if pernah "bg %"; then ((SKOR4+=5)); fi
if pernah "kill %"; then ((SKOR4+=5)); fi
if [ $SKOR4 -ge 20 ]; then
    echo "✅ 20"
    NILAI_EX4=20
elif [ $SKOR4 -ge 10 ]; then
    echo "⚠️ 10"
    NILAI_EX4=10
else
    echo "❌ 0"
fi

echo -n "Exercise 5 (signal handling): "
if pernah "sleep 60 &"; then
    if pernah "kill [0-9]" && ! pernah "kill -9"; then
        echo "✅ 20"
        NILAI_EX5=20
    elif pernah "kill -9"; then
        echo "⚠️ 10"
        NILAI_EX5=10
    else
        echo "❌ 0"
    fi
else
    echo "❌ 0"
fi

TOTAL_EX=$((NILAI_EX1 + NILAI_EX2 + NILAI_EX3 + NILAI_EX4 + NILAI_EX5))
echo "=============================================="
echo "🎯 TOTAL EXERCISE = $TOTAL_EX / 100"
grade_ex=$(if [ $TOTAL_EX -ge 81 ]; then echo "A (Sepuh)"; elif [ $TOTAL_EX -ge 75 ]; then echo "B+ (Very Good)"; elif [ $TOTAL_EX -ge 70 ]; then echo "B (Good)"; elif [ $TOTAL_EX -ge 60 ]; then echo "C+ (Fairly Good)"; elif [ $TOTAL_EX -ge 55 ]; then echo "C (Fair)"; elif [ $TOTAL_EX -ge 41 ]; then echo "D (Poor)"; else echo "E (Bro really...)"; fi)
echo "📝 GRADE EXERCISE: $grade_ex"
echo ""

# ==================== PRACTICE 1 ====================
echo "=============================================="
echo "        PENILAIAN PRACTICE 1 (Job Control)"
echo "=============================================="

DIR1=$(cari_folder_case_insensitive "LatihanProses1")
SKOR1=0

if [ -n "$DIR1" ]; then
    echo "✅ Folder ditemukan: $DIR1"
    ((SKOR1+=10))
else
    echo "❌ Folder LatihanProses1 tidak ditemukan di $HOME"
fi

if [ -n "$DIR1" ] && [ -f "$DIR1/loop.sh" ]; then
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
grade_p1=$(if [ $SKOR1 -ge 81 ]; then echo "A (Sepuh)"; elif [ $SKOR1 -ge 75 ]; then echo "B+ (Very Good)"; elif [ $SKOR1 -ge 70 ]; then echo "B (Good)"; elif [ $SKOR1 -ge 60 ]; then echo "C+ (Fairly Good)"; elif [ $SKOR1 -ge 55 ]; then echo "C (Fair)"; elif [ $SKOR1 -ge 41 ]; then echo "D (Poor)"; else echo "E (Bro really...)"; fi)
echo "📝 GRADE PRACTICE 1: $grade_p1"
echo ""

# ==================== PRACTICE 2 ====================
echo "=============================================="
echo "        PENILAIAN PRACTICE 2 (Debug SSH)"
echo "=============================================="

DIR2=$(cari_folder_case_insensitive "LatihanProses2")
SKOR2=0

if [ -n "$DIR2" ]; then
    echo "✅ Folder ditemukan: $DIR2"
    ((SKOR2+=10))
else
    echo "❌ Folder LatihanProses2 tidak ditemukan di $HOME"
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
grade_p2=$(if [ $SKOR2 -ge 81 ]; then echo "A (Sepuh)"; elif [ $SKOR2 -ge 75 ]; then echo "B+ (Very Good)"; elif [ $SKOR2 -ge 70 ]; then echo "B (Good)"; elif [ $SKOR2 -ge 60 ]; then echo "C+ (Fairly Good)"; elif [ $SKOR2 -ge 55 ]; then echo "C (Fair)"; elif [ $SKOR2 -ge 41 ]; then echo "D (Poor)"; else echo "E (Bro really...)"; fi)
echo "📝 GRADE PRACTICE 2: $grade_p2"
echo ""

# ==================== KESIMPULAN AKHIR ====================
echo "=============================================="
echo "            RINGKASAN NILAI FINAL"
echo "=============================================="
echo "📊 EXERCISE (5 soal) : $TOTAL_EX / 100 ($grade_ex)"
echo "📊 PRACTICE 1        : $SKOR1 / 100 ($grade_p1)"
echo "📊 PRACTICE 2        : $SKOR2 / 100 ($grade_p2)"
echo "=============================================="

# Rata-rata jika diperlukan
RATA=$(( (TOTAL_EX + SKOR1 + SKOR2) / 3 ))
echo "⭐ RATA-RATA KESELURUHAN: $RATA / 100"
if [ $RATA -ge 81 ]; then echo "🏆 FINAL GRADE: A (Sepuh)"
elif [ $RATA -ge 75 ]; then echo "🏆 FINAL GRADE: B+ (Very Good)"
elif [ $RATA -ge 70 ]; then echo "🏆 FINAL GRADE: B (Good)"
elif [ $RATA -ge 60 ]; then echo "🏆 FINAL GRADE: C+ (Fairly Good)"
elif [ $RATA -ge 55 ]; then echo "🏆 FINAL GRADE: C (Fair)"
elif [ $RATA -ge 41 ]; then echo "🏆 FINAL GRADE: D (Poor)"
else echo "🏆 FINAL GRADE: E (Bro really...)"
fi
echo "=============================================="
