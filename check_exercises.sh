#!/bin/bash

# ==================================================
# PENILAIAN EXERCISE 1-5 (ABSOLUTE PATH)
# Mencari di $HOME dan membaca history dari user
# ==================================================

HISTORY_FILE=~/.bash_history
if [ ! -f "$HISTORY_FILE" ]; then
    echo "❌ File history tidak ditemukan. Jalankan 'history -a' terlebih dahulu."
    exit 1
fi

pernah() {
    grep -q "$1" "$HISTORY_FILE"
}

echo "========== PENILAIAN EXERCISE (ABSOLUTE) =========="

NILAI_EX1=0
NILAI_EX2=0
NILAI_EX3=0
NILAI_EX4=0
NILAI_EX5=0

# Exercise 1 (ping lifecycle)
echo -n "Exercise 1: "
if pernah "ping -c 5 google.com"; then
    if pernah "ps aux | grep ping"; then
        echo "✅ Nilai 20"
        NILAI_EX1=20
    else
        echo "⚠️ Nilai 10"
        NILAI_EX1=10
    fi
else
    echo "❌ Nilai 0"
fi

# Exercise 2 (zombie/orphan)
echo -n "Exercise 2: "
if pernah "ps aux | grep Z" || pernah "ps aux | grep defunct"; then
    echo "✅ Nilai 20"
    NILAI_EX2=20
elif ps aux | grep -q " Z "; then
    echo "⚠️ Ada zombie sekarang tapi tidak tercatat di history → Nilai 10"
    NILAI_EX2=10
else
    echo "❌ Nilai 0"
fi

# Exercise 3 (top per-core)
echo -n "Exercise 3: "
if pernah "top"; then
    echo "✅ Nilai 20"
    NILAI_EX3=20
else
    echo "❌ Nilai 0"
fi

# Exercise 4 (job control)
echo -n "Exercise 4: "
SKOR4=0
if pernah "sleep 30 &"; then ((SKOR4+=5)); fi
if pernah "jobs"; then ((SKOR4+=5)); fi
if pernah "fg %"; then ((SKOR4+=5)); fi
if pernah "bg %"; then ((SKOR4+=5)); fi
if pernah "kill %"; then ((SKOR4+=5)); fi
if [ $SKOR4 -ge 20 ]; then
    echo "✅ Nilai 20"
    NILAI_EX4=20
elif [ $SKOR4 -ge 10 ]; then
    echo "⚠️ Nilai 10"
    NILAI_EX4=10
else
    echo "❌ Nilai 0"
fi

# Exercise 5 (signal handling)
echo -n "Exercise 5: "
if pernah "sleep 60 &"; then
    if pernah "kill [0-9]" && ! pernah "kill -9"; then
        echo "✅ Nilai 20"
        NILAI_EX5=20
    elif pernah "kill -9"; then
        echo "⚠️ Nilai 10"
        NILAI_EX5=10
    else
        echo "❌ Nilai 0"
    fi
else
    echo "❌ Nilai 0"
fi

TOTAL=$((NILAI_EX1 + NILAI_EX2 + NILAI_EX3 + NILAI_EX4 + NILAI_EX5))
echo "=============================================="
echo "✅ EXERCISE 1: $NILAI_EX1 | EX2: $NILAI_EX2 | EX3: $NILAI_EX3 | EX4: $NILAI_EX4 | EX5: $NILAI_EX5"
echo "🎯 TOTAL EXERCISE = $TOTAL / 100"

# Grade
if [ $TOTAL -ge 81 ]; then echo "📝 GRADE: A (Sepuh)"
elif [ $TOTAL -ge 75 ]; then echo "📝 GRADE: B+ (Very Good)"
elif [ $TOTAL -ge 70 ]; then echo "📝 GRADE: B (Good)"
elif [ $TOTAL -ge 60 ]; then echo "📝 GRADE: C+ (Fairly Good)"
elif [ $TOTAL -ge 55 ]; then echo "📝 GRADE: C (Fair)"
elif [ $TOTAL -ge 41 ]; then echo "📝 GRADE: D (Poor)"
else echo "📝 GRADE: E (Bro really...)"
fi
echo "=============================================="