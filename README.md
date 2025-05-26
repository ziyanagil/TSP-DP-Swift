## Deskripsi

Program ini menyelesaikan Traveling Salesman Problem (TSP) menggunakan algoritma Dynamic Programming. Input dapat dibaca dari file `<nama_file_input>.txt`.

## Struktur Direktori

```
TSP-DP-Swift/
├── Package.swift          # File konfigurasi Swift Package Manager
├── README.md              # Dokumentasi program
├── input/                 # File input contoh
│   ├── test1.txt
│   ├── test2.txt
│   ├── test3.txt
│   ├── test4.txt
│   └── test5.txt
├── Results/               # Output hasil eksekusi
└── Sources/               # Kode sumber program
    └── TSP/
        └── main.swift     # Implementasi TSP DP
```

## Format File Input

Isi `<nama_file_input>.txt`:

```text
n            # jumlah simpul
w[0][0] w[0][1] ... w[0][n-1]
w[1][0] ...
w[n-1][0] ... w[n-1][n-1]
```

Gunakan nilai besar (misal `1000000000`) untuk menyatakan tidak ada tepi.

## Persiapan & Instalasi Dependensi

### 1. Linux / WSL (Ubuntu 20.04+)

1. **Update & install paket dasar**

   ```bash
   sudo apt update
   sudo apt install -y \
     clang libicu-dev libpython3.10 libpython3.10-dev \
     libncurses5-dev libxml2-dev zlib1g libbsd0 \
     pkg-config wget tar
   ```
2. **Unduh Swift toolchain**
   Cek rilis terbaru di [https://swift.org/download/](https://swift.org/download/). Contoh untuk Swift 5.9.1 di Ubuntu 20.04:

   ```bash
   cd ~
   wget https://download.swift.org/swift-5.9.1-release/ubuntu2004/swift-5.9.1-RELEASE/swift-5.9.1-RELEASE-ubuntu20.04.tar.gz
   ```
3. **Ekstrak ke /usr/share**

   ```bash
   sudo tar xzf swift-5.9.1-RELEASE-ubuntu20.04.tar.gz -C /usr/share
   ```
4. **Tambahkan ke PATH**
   Tambahkan baris ini ke `~/.bashrc` atau `~/.profile`:

   ```bash
   export PATH=/usr/share/swift-5.9.1-RELEASE-ubuntu20.04/usr/bin:$PATH
   source ~/.bashrc
   # atau
   source ~/.profile
   ```
5. **(Opsional) Atasi konflik dengan OpenStack Swift CLI**
   Jika masih terpanggil OpenStack CLI (`which swift` menunjukkan `/usr/bin/swift`), buat symlink permanen:

   ```bash
   sudo ln -sf /usr/share/swift-5.9.1-RELEASE-ubuntu20.04/usr/bin/swift  /usr/bin/swift
   sudo ln -sf /usr/share/swift-5.9.1-RELEASE-ubuntu20.04/usr/bin/swiftc /usr/bin/swiftc
   ```
6. **Verifikasi**

   ```bash
   swift --version
   # Harus menampilkan:
   # Swift version 5.9.1 (swift-5.9.1-RELEASE)
   # Target: x86_64-unknown-linux-gnu
   ```

### 2. Windows (PowerShell)

1. **Unduh Swift for Windows**
   Download installer ZIP/EXE dari [https://swift.org/download/#releases](https://swift.org/download/#releases).
2. **Instal / ekstrak**
   Jika ZIP: ekstrak ke misalnya
   `C:\Library\Developer\Toolchains\swift-5.9.1-RELEASE\`
   Jika EXE: jalankan installer dan ikuti instruksi.
3. **Set PATH**
   Buka Environment Variables → System variables → Path → Edit.
   Tambahkan:

   ```text
   C:\Library\Developer\Toolchains\swift-5.9.1-RELEASE\usr\bin
   ```
4. **Verifikasi**
   Buka PowerShell baru:

   ```powershell
   swift --version
   ```

### 3. macOS

1. **Xcode & SwiftPM**
   Pastikan Xcode (atau Command Line Tools) sudah terinstall:

   ```bash
   xcode-select --install
   ```
2. **Verifikasi Swift**

   ```bash
   swift --version
   ```

Setelah dependensi terpasang dan swift mengarah ke toolchain yang benar, jalankan:

```bash
git clone https://github.com/ziyanagil/TSP-DP-Swift.git
cd TSP-DP-Swift
swift build -c release
swift run TSP input/<nama_file_input>.txt
```
