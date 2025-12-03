/// Membuat Tabel Dasar (USER, PACKAGE, THEME) ///

CREATE TABLE USER (
    user_id BIGINT PRIMARY KEY,
    nama_lengkap VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    no_telp VARCHAR(20),
    tanggal_daftar DATETIME NOT NULL,
    role VARCHAR(50) NOT NULL -- Constraint: 'admin' atau 'pelanggan'
);

-- Tabel PACKAGE
CREATE TABLE PACKAGE (
    package_id BIGINT PRIMARY KEY,
    nama_packet VARCHAR(100) UNIQUE NOT NULL,
    harga DECIMAL(10, 2) NOT NULL CHECK (harga >= 0),
    fitur TEXT
);

-- Tabel THEME
CREATE TABLE THEME (
    theme_id BIGINT PRIMARY KEY,
    nama_tema VARCHAR(100) UNIQUE NOT NULL,
    keterangan_tema VARCHAR(1000) NOT NULL,
    url_preview VARCHAR(255),
    harga DECIMAL(10, 2) NOT NULL CHECK (harga >= 0)
);

/// Membuat Tabel Relasi Utama (INVITATION, ORDER) ///

-- Tabel INVITATION
CREATE TABLE INVITATION (
    invitation_id BIGINT PRIMARY KEY,
    theme_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    judul_acara VARCHAR(255) NOT NULL,
    jenis_acara VARCHAR(100) NOT NULL,
    tanggal_acara DATE NOT NULL,
    link_undangan VARCHAR(255) UNIQUE NOT NULL,
    status VARCHAR(50) NOT NULL, -- Constraint: 'draft' atau 'publish'
    updated_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (theme_id) REFERENCES THEME(theme_id)
);

-- Tabel ORDERED
CREATE TABLE ORDER_TABLE ( -- Menggunakan ORDER_TABLE karena ORDER adalah reserved keyword
    user_id BIGINT NOT NULL,
    package_id BIGINT NOT NULL,
    ordered_id BIGINT NOT NULL,
    tanggal_order DATETIME NOT NULL,
    status_order VARCHAR(50),
    total_bayar DECIMAL(16, 2), -- Tambahan atribut dari Analisis Kebutuhan
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (package_id) REFERENCES PACKAGE(package_id)
);

/// Membuat Tabel Detail Relasi (GUEST, WISHES, GALLERY, PAYMENT) ///

-- Tabel GUEST (Tamu Undangan)
CREATE TABLE GUEST (
    guest_id BIGINT PRIMARY KEY,
    invitation_id BIGINT NOT NULL,
    nama_tamu VARCHAR(255) NOT NULL,
    noone_telp VARCHAR(20),
    alamat VARCHAR(255),
    kode_unik VARCHAR(50) UNIQUE, -- UNIQUE per undangan (dapat diimplementasikan dengan composite unique key: (invitation_id, kode_unik))
    status_konfirmasi VARCHAR(50) DEFAULT 'Belum Konfirmasi', -- Default Value
    FOREIGN KEY (invitation_id) REFERENCES INVITATION(invitation_id)
);

-- Tabel WISHES (Ucapan & Doa)
CREATE TABLE WISHES (
    wish_id BIGINT PRIMARY KEY,
    invitation_id BIGINT NOT NULL,
    nama_pengirim VARCHAR(255) NOT NULL,
    pesan TEXT NOT NULL,
    tanggal_kirim DATETIME NOT NULL,
    FOREIGN KEY (invitation_id) REFERENCES INVITATION(invitation_id)
);
-- Tabel GALLERY
CREATE TABLE GALLERY (
    media_id BIGINT PRIMARY KEY,
    invitation_id BIGINT NOT NULL,
    uri_media VARCHAR(255) NOT NULL,
    jenis_media VARCHAR(50) NOT NULL, -- Constraint: 'foto' atau 'video'
    deskripsi TEXT,
    FOREIGN KEY (invitation_id) REFERENCES INVITATION(invitation_id)
);

-- Tabel PAYMENT (Amplop Digital/Pembayaran Order)
CREATE TABLE PAYMENT (
    payment_id BIGINT PRIMARY KEY,
    invitation_id BIGINT, -- Untuk mencatat Amplop Digital (jika terpisah dari Order)
    order_id BIGINT, -- Untuk mencatat pembayaran order
    nama_pengirim VARCHAR(255),
    nominal DECIMAL(10, 2) NOT NULL,
    metode_pembayaran VARCHAR(100),
    tanggal_transaksi DATETIME NOT NULL,
    status_transaksi VARCHAR(50) NOT NULL, -- Constraint: 'sukses', 'pending', 'gagal'
    FOREIGN KEY (invitation_id) REFERENCES INVITATION(invitation_id),
    FOREIGN KEY (order_id) REFERENCES ORDER_TABLE(order_id)
);

/// CREATE (INSERT Data Baru) //

-- INSERT data ke tabel USER (Simulasi pendaftaran pengguna)
INSERT INTO USER (user_id, nama_lengkap, email, password_hash, no_telp, tanggal_daftar, role)
VALUES (1, 'Budi Santoso', 'budi.s@gmail.com', 'hashed_pass_123', '081234567890', NOW(), 'pelanggan');

-- INSERT data ke tabel THEME
INSERT INTO THEME (theme_id, nama_tema, kategori_tema, url_preview, harga)
VALUES (101, 'Romantic Floral', 'Pernikahan', 'link.url/preview/101', 50000.00);

-- INSERT data ke tabel INVITATION (Pengguna 1 membuat undangan)
INSERT INTO INVITATION (invitation_id, user_id, theme_id, judul_acara, jenis_acara, tanggal_acara, lokasi_acara, link_undangan, status, created_at)
VALUES (
    201,
    1,
    101,
    'Pernikahan Budi & Rina',
    'Pernikahan',
    '2024-06-01',
    'Gedung Serbaguna Jakarta',
    'link.url/inv/budi-rina',
    'publish',
    NOW()
);
-- INSERT data ke tabel PACKAGE
INSERT INTO PACKAGE (package_id, nama_paket, harga, fitur)
VALUES (100, 'Gold Sep', 500000.00, 'Fitur dasar: Link undangan, peta');

-- INSERT data ke tabel GUEST
INSERT INTO GUEST (guest_id, invitation_id, nama_tamu, kode_unik, status_kehadiran)
VALUES (200, 2021, 'Soko Sudi', 'GUEST001', 'hadir');

INSERT INTO GUEST (guest_id, invitation_id, nama_tamu, kode_unik, status_kehadiran)
VALUES (201, 2021, 'Soko Sudi', 'GUEST002', 'tidak hadir');

INSERT INTO GUEST (guest_id, invitation_id, nama_tamu, kode_unik, status_kehadiran)
VALUES (202, 2021, 'Soko Sudi', 'GUEST003', 'Belum Konfirmasi');

-- INSERT data ke tabel WISHES
INSERT INTO WISHES (wish_id, invitation_id, nama_pengirim, pesan, tanggal_kirim)
VALUES (601, 2021, 'Ketut Budi', 'Semoga Sakinah Mawaddah Warahmah.', NOW());

-- INSERT data ke tabel PAYMENT
INSERT INTO PAYMENT (payment_id, invitation_id, nama_pengirim, nominal, metode_pembayaran, tanggal_transaksi, status_transaksi)
VALUES (701, 2021, 'IIN ANIT', 250000.00, 'Transfer Bank', NOW(), 'Sukses');
