import Foundation

// Parse integers dari sebuah string
func parseInts(from line: String) -> [Int] {
    return line.split(separator: " ").compactMap { Int($0) }
}

// Baca input dari file atau stdin
let args = CommandLine.arguments
let content: String

if args.count > 1 {
    // Baca dari file path yang diberikan
    let path = args[1]
    guard let fileText = try? String(contentsOfFile: path, encoding: .utf8) else {
        fatalError("Tidak dapat membaca file di: \(path)")
    }
    content = fileText
} else {
    // Baca dari stdin
    let data = FileHandle.standardInput.readDataToEndOfFile()
    guard let text = String(data: data, encoding: .utf8) else {
        fatalError("Gagal membaca stdin")
    }
    content = text
}

// Split lines dan buang baris kosong
let rawLines = content.components(separatedBy: .newlines)
let lines = rawLines.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

guard let n = Int(lines.first!) else {
    fatalError("Baris pertama harus jumlah simpul (Int)")
}

// Validasi jumlah baris matriks
guard lines.count == n + 1 else {
    fatalError("""
Ditemukan \(lines.count - 1) baris matriks, seharusnya \(n).
Format input harus:
  n
  n x n matriks
""")
}

// Inisialisasi matriks bobot
var weight = [[Int]](
    repeating: [Int](repeating: Int(1e9), count: n),
    count: n
)

// Parsing dan validasi setiap baris
for i in 0..<n {
    let row = parseInts(from: lines[i + 1])
    guard row.count == n else {
        fatalError("Baris \(i + 1) harus memiliki \(n) angka, ditemukan \(row.count)")
    }
    for j in 0..<n {
        weight[i][j] = row[j]
    }
}

// TSP dengan Dynamic Programming menggunakan Held-Karp algorithm
func solveTSP() -> (cost: Int, path: [Int]) {
    let INF = Int(1e9)
    
    // dp[mask][i] = minimum cost untuk mengunjungi semua kota dalam mask dan berakhir di kota i
    var dp = [[Int]](repeating: [Int](repeating: INF, count: n), count: 1 << n)
    
    // parent[mask][i] = kota sebelumnya dalam path optimal untuk state (mask, i)
    var parent = [[Int]](repeating: [Int](repeating: -1, count: n), count: 1 << n)
    
    // Base case: mulai dari kota 0
    dp[1][0] = 0
    
    // Iterasi untuk setiap subset kota (mask)
    for mask in 0..<(1 << n) {
        for u in 0..<n {
            // Skip jika kota u tidak ada dalam mask atau cost tidak terhingga
            if (mask & (1 << u)) == 0 || dp[mask][u] == INF {
                continue
            }
            
            // Coba pindah ke kota v
            for v in 0..<n {
                if (mask & (1 << v)) != 0 { // v sudah dikunjungi
                    continue
                }
                
                let newMask = mask | (1 << v)
                let newCost = dp[mask][u] + weight[u][v]
                
                if newCost < dp[newMask][v] {
                    dp[newMask][v] = newCost
                    parent[newMask][v] = u
                }
            }
        }
    }
    
    // Cari cost minimum untuk kembali ke kota 0 setelah mengunjungi semua kota
    let finalMask = (1 << n) - 1 // Semua bit di-set
    var minCost = INF
    var lastCity = -1
    
    for i in 1..<n { // Skip kota 0 karena kita mulai dari sana
        let totalCost = dp[finalMask][i] + weight[i][0]
        if totalCost < minCost {
            minCost = totalCost
            lastCity = i
        }
    }
    
    // Reconstruct path
    var path = [Int]()
    var currentMask = finalMask
    var currentCity = lastCity
    
    while currentCity != -1 {
        path.append(currentCity)
        let prevCity = parent[currentMask][currentCity]
        currentMask ^= (1 << currentCity) // Remove current city from mask
        currentCity = prevCity
    }
    
    path.reverse()
    path.append(0) // Kembali ke kota awal
    
    return (cost: minCost, path: path)
}

// Validasi input untuk TSP
func validateTSPInput() -> Bool {
    // Cek apakah semua jarak non-negatif (kecuali untuk kota yang sama)
    for i in 0..<n {
        for j in 0..<n {
            if i == j && weight[i][j] != 0 {
                print("Warning: Jarak dari kota \(i) ke dirinya sendiri bukan 0: \(weight[i][j])")
            }
            if i != j && weight[i][j] < 0 {
                print("Error: Jarak negatif ditemukan dari kota \(i) ke kota \(j): \(weight[i][j])")
                return false
            }
        }
    }
    return true
}

// Main execution
print("Menyelesaikan TSP untuk \(n) kota...")

// Validasi input
guard validateTSPInput() else {
    fatalError("Input tidak valid untuk TSP")
}

// Cek apakah n terlalu besar (kompleksitas eksponensial)
if n > 20 {
    print("Warning: n = \(n) mungkin terlalu besar. Algoritma DP untuk TSP memiliki kompleksitas O(n²2ⁿ)")
    print("Untuk n > 20, waktu eksekusi bisa sangat lama.")
}

// Solve TSP
let startTime = Date()
let result = solveTSP()
let endTime = Date()

// Output hasil
print("\n=== HASIL TSP ===")
print("Cost minimum: \(result.cost)")
print("Path optimal: \(result.path.map { String($0) }.joined(separator: " -> "))")
print("Waktu eksekusi: \(String(format: "%.3f", endTime.timeIntervalSince(startTime))) detik")

// Verifikasi hasil
func verifyPath(_ path: [Int]) -> Int {
    var totalCost = 0
    for i in 0..<path.count - 1 {
        totalCost += weight[path[i]][path[i + 1]]
    }
    return totalCost
}

let verifiedCost = verifyPath(result.path)
print("Verifikasi cost: \(verifiedCost)")

if verifiedCost != result.cost {
    print("ERROR: Cost yang dihitung tidak sesuai dengan path!")
} else {
    print("✓ Verifikasi berhasil")
}