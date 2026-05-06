#!/bin/bash

echo "========== CEPAT CEK EXERCISE 1-5 =========="

# Exercise 1: Apakah pernah menjalankan ping? (cek history)
echo -n "Exercise 1 (ping lifecycle): "
if history | grep -q "ping -c 5 google.com"; then
    echo "✅ Terdeteksi perintah ping"
else
    echo "❌ Belum menjalankan ping"
fi

# Exercise 3: Apakah top pernah dijalankan? (cek proses top di history)
echo -n "Exercise 3 (top per-core): "
if history | grep -q "top"; then
    echo "✅ Pernah menjalankan top"
else
    echo "❌ Belum"
fi

# Exercise 4 & 5: Cek apakah pernah job control & kill
echo -n "Exercise 4 & 5 (job control & signal): "
if history | grep -E "sleep [0-9]+ &" | grep -q "kill"; then
    echo "✅ Terdeteksi sleep background dan kill"
else
    echo "❌ Belum lengkap"
fi

# Cek ada proses zombie sekarang (kalau Exercise 2 minta zombie)
echo -n "Exercise 2 (zombie process): "
if ps aux | grep -q " Z "; then
    echo "⚠️ Ada proses zombie (jika diminta)"
else
    echo "✅ Tidak ada zombie (atau tidak diperlukan)"
fi

echo "================= SELESAI ================="