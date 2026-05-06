#!/bin/bash

# ========================
# CEK NILAI EXERCISE 1-5
# ========================

HISTORY_FILE=~/.bash_history
if [ ! -f "$HISTORY_FILE" ]; then
    echo "❌ File history tidak ditemukan. Pastikan bash menyimpan history."
    echo "   Jalankan 'history -a' dulu atau gunakan shell yang sama."
    exit 1
fi

# Fungsi untuk cek ada perintah dalam history
pernah() {
    grep -q "$1" "$HISTORY_FILE"
}

# Inisialisasi nilai
NILAI_EX1=0
NILAI_EX2=0
NILAI_EX3=0
NILAI_EX4=0
NILAI_EX5=0

echo "========== PENILAIAN OTOMATIS EXERCISE =========="

# ---------- EXERCISE 1 ----------
echo -n "Exercise 1 (lifecycle ping): "
if pernah "ping -c 5 google.com"; then
    echo -n "✅ Perintah ping ditemukan. "
    if pernah "ps aux | grep ping"; then
        echo "✅ Juga ada ps grep ping → Nilai 20"
        NILAI_EX1=20
    else
        echo "⚠️ Tidak ada 'ps aux | grep ping' untuk observasi → Nilai 10"
        NILAI_EX1=10
    fi
else
    echo "❌ Tidak ada perintah ping → Nilai 0"
fi

# ---------- EXERCISE 2 (Zombie/Orphan) ----------
echo -n "Exercise 2 (zombie/orphan): "
if pernah "ps aux | grep Z" || pernah "ps aux | grep defunct"; then
    echo "✅ Pernah mengecek proses zombie → Nilai 20"
    NILAI_EX2=20
elif pernah "pstree -p"; then
    echo "⚠️ Ada pstree tapi tidak langsung cek zombie → Nilai 10"
    NILAI_EX2=10
else
    # Cek apakah saat ini ada zombie
    if ps aux | grep -q " Z "; then
        echo "⚠️ Ada proses zombie berjalan sekarang (tapi tidak tercatat di history) → Nilai 10"
        NILAI_EX2=10
    else
        echo "❌ Tidak ditemukan indikasi pemahaman zombie/orphan → Nilai 0"
    fi
fi

# ---------- EXERCISE 3 ----------
echo -n "Exercise 3 (top & per-core CPU): "
if pernah "top"; then
    echo "✅ Pernah menjalankan top → Nilai 20"
    NILAI_EX3=20
    # Catatan: Menekan '1' tidak bisa dideteksi. Dianggap sudah jika top pernah.
else
    echo "❌ Tidak pernah menjalankan top → Nilai 0"
fi

# ---------- EXERCISE 4 (Job control) ----------
echo -n "Exercise 4 (job control): "
SKOR4=0
if pernah "sleep 30 &"; then ((SKOR4+=5)); fi
if pernah "jobs"; then ((SKOR4+=5)); fi
if pernah "fg %"; then ((SKOR4+=5)); fi
if pernah "bg %"; then ((SKOR4+=5)); fi
if pernah "kill %"; then ((SKOR4+=5)); fi
# Ctrl+Z tidak bisa dicek, jadi maksimum 25? Kita beri skala 20.
if [ $SKOR4 -ge 20 ]; then
    echo "✅ Semua perintah job control terdeteksi (sleep, jobs, fg, bg, kill) → Nilai 20"
    NILAI_EX4=20
elif [ $SKOR4 -ge 10 ]; then
    echo "⚠️ Sebagian perintah job control ($SKOR4/25 poin) → Nilai 10"
    NILAI_EX4=10
else
    echo "❌ Kurang bukti job control → Nilai 0"
fi

# ---------- EXERCISE 5 (SIGTERM dulu) ----------
echo -n "Exercise 5 (signal handling): "
if pernah "sleep 60 &"; then
    # Cek apakah ada kill tanpa -9 dan dilanjutkan cek ps
    if pernah "kill [0-9]" && ! pernah "kill -9"; then
        echo "✅ Ada kill biasa (SIGTERM) tanpa -9 → Nilai 20"
        NILAI_EX5=20
    elif pernah "kill -9"; then
        echo "⚠️ Menggunakan SIGKILL langsung tanpa SIGTERM → Nilai 10"
        NILAI_EX5=10
    else
        echo "❌ Tidak ada perintah kill → Nilai 0"
    fi
else
    echo "❌ Tidak menjalankan sleep 60 & → Nilai 0"
fi

# TOTAL NILAI (masing2 maks 20)
TOTAL=$((NILAI_EX1 + NILAI_EX2 + NILAI_EX3 + NILAI_EX4 + NILAI_EX5))

echo "=============================================="
echo "✅ NILAI EXERCISE 1: $NILAI_EX1 / 20"
echo "✅ NILAI EXERCISE 2: $NILAI_EX2 / 20"
echo "✅ NILAI EXERCISE 3: $NILAI_EX3 / 20"
echo "✅ NILAI EXERCISE 4: $NILAI_EX4 / 20"
echo "✅ NILAI EXERCISE 5: $NILAI_EX5 / 20"
echo "=============================================="
echo "🎯 TOTAL NILAI = $TOTAL / 100"

# Konversi ke huruf (berdasarkan skala modul)
if [ $TOTAL -ge 81 ]; then
    echo "📝 GRADE: A (Sepuh)"
elif [ $TOTAL -ge 75 ]; then
    echo "📝 GRADE: B+ (Very Good)"
elif [ $TOTAL -ge 70 ]; then
    echo "📝 GRADE: B (Good)"
elif [ $TOTAL -ge 60 ]; then
    echo "📝 GRADE: C+ (Fairly Good)"
elif [ $TOTAL -ge 55 ]; then
    echo "📝 GRADE: C (Fair)"
elif [ $TOTAL -ge 41 ]; then
    echo "📝 GRADE: D (Poor)"
else
    echo "📝 GRADE: E (Bro really...)"
fi
echo "=============================================="