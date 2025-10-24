program kelompok2;
uses crt, SysUtils, DateUtils;

type
    // Linked List item pesanan
    PItem = ^TItem;
    TItem = record
        namaMenu: string[50];
        harga: longint;
        jumlah: integer;
        next: PItem;
    end;

    // Record data transaksi (BUKAN Linked List)
    TTransaksi = record
        tahun, bulan, hari, jam, menit, detik, mdetik: word;
        namaKasir: string[50];
        jenisPesanan: string[15];
        nomorMeja: string[10];
        head: PItem;
        totalHarga: longint;
    end;

    // Stack untuk riwayat transaksi
    PHistory = ^THistory;
    THistory = record
        transaksi: TTransaksi;
        next: PHistory;
    end;

var 
    historyStack: PHistory;
    transaksi: TTransaksi; // hanya satu transaksi aktif

procedure InisialisasiTransaksi(var T: TTransaksi; NamaKasir, JenisPesanan, NomorMeja: string);
begin
    T.namaKasir := NamaKasir;
    T.jenisPesanan := JenisPesanan;
    T.nomorMeja := NomorMeja;
    T.head := nil;
    T.totalHarga := 0;
end;

procedure TambahPesanan(var T: TTransaksi; NamaMenu: string; Harga: longint; Jumlah: integer);
var
    newItem, current: PItem;
begin
    New(newItem);
    newItem^.namaMenu := NamaMenu;
    newItem^.harga := Harga;
    newItem^.jumlah := Jumlah;
    newItem^.next := nil;

    if T.head = nil then
        T.head := newItem
    else
    begin
        current := T.head;
        while current^.next <> nil do
            current := current^.next;
        current^.next := newItem;
    end;

    T.totalHarga := T.totalHarga + (Harga * Jumlah);
end;

procedure TampilkanPesanan(T: TTransaksi);
var
    Temp: PItem;
    Counter: integer;
begin
    clrscr;
    writeln('======= DAFTAR PESANAN =======');
    writeln('Nama Kasir: ', T.namaKasir);
    writeln('Jenis Pesanan: ', T.jenisPesanan);
    if T.jenisPesanan = 'dine-in' then
        writeln('Nomor Meja: ', T.nomorMeja);
    writeln('-------------------------------');

    Counter := 1;
    Temp := T.head;
    while Temp <> nil do
    begin
        writeln(Counter, '. ', Temp^.namaMenu);
        writeln('   Harga: Rp. ', Temp^.harga);
        writeln('   Jumlah: ', Temp^.jumlah);
        writeln('   Subtotal: Rp. ', Temp^.harga * Temp^.jumlah);
        writeln;
        Temp := Temp^.next;
        Inc(Counter);
    end;
    writeln('Total sebelum pajak: Rp. ', T.totalHarga);
    writeln();
end;

procedure HapusPesanan(var T: TTransaksi; Nomor: integer);
var
    Temp, Prev: PItem;
    Counter: integer;
begin
    if T.head = nil then
    begin
        writeln('Tidak ada pesanan untuk dihapus.');
        exit;
    end;

    if Nomor = 1 then
    begin
        Temp := T.head;
        T.totalHarga := T.totalHarga - (Temp^.harga * Temp^.jumlah);
        T.head := T.head^.next;
        dispose(temp);
        writeln('Pesanan nomor ', Nomor, ' telah dihapus.');
    end
    else
    begin
        Counter := 1;
        Prev := nil;
        Temp := T.head;

        while (Temp <> nil) and (Counter < Nomor) do
        begin
            Prev := Temp;
            Temp := Temp^.next;
            Inc(Counter);
        end;
    
        if Temp = nil then
            writeln('Nomor pesanan tidak valid.')
        else 
        begin
            T.totalHarga := T.totalHarga - (Temp^.harga * Temp^.jumlah); // Diperbaiki: = menjadi :=
            Prev^.next := Temp^.next;
            Dispose(Temp);
            writeln('Pesanan nomor ', Nomor, ' telah dihapus.');
        end;
    end;
end;

procedure EditJumlahPesanan(var T: TTransaksi; Nomor, JumlahBaru: integer);
var
    Temp: PItem;
    Counter: integer;
    SubtotalLama: longint;
begin
    if T.head = nil then
    begin
        writeln('Pesanan kosong!');
        exit;
    end;

    Counter := 1;
    Temp := T.head;

    while (Temp <> nil) and (Counter < Nomor) do
    begin
        Temp := Temp^.next;
        Inc(Counter);
    end;

    if Temp = nil then
        writeln('Nomor pesanan tidak valid.')
    else
    begin
        // kurangi total dengan subtotal lama
        SubtotalLama := Temp^.harga * Temp^.jumlah;
        T.totalHarga := T.totalHarga - SubtotalLama;

        // update jumlah
        Temp^.jumlah := JumlahBaru;

        // tambahkan subtotal baru ke total
        T.totalHarga := T.totalHarga + (Temp^.harga * Temp^.jumlah); // Diperbaiki: Total menjadi totalHarga
        writeln('Jumlah pesanan nomor ', Nomor, ' telah diupdate menjadi ', JumlahBaru, '.');
    end;
end;

function HitungTotalAkhir(Total: LongInt): LongInt;
var
    totalSetelahPajak: longint;
begin
    // tambah pajak 10%
    totalSetelahPajak := Total + round(Total * 0.1);

    // cek diskon 5% jika total > 150000
    if totalSetelahPajak > 150000 then
        HitungTotalAkhir := totalSetelahPajak - round(totalSetelahPajak * 0.05)
    else
        HitungTotalAkhir := totalSetelahPajak;
end;

procedure TampilkanStrukAkhir(T: TTransaksi);
var
    Temp: PItem;
    Counter: integer;
    TotalAkhir, Pajak, Diskon: longint;
    waktuSekarang: TDateTime;
    tahun, bulan, hari, jam, menit, detik, mdetik: word;
begin
    clrscr;
    waktuSekarang := Now;
    DecodeDate(waktuSekarang, tahun, bulan, hari);
    DecodeTime(waktuSekarang, jam, menit, detik, mdetik);

    writeln('--------------------------------------------------------------');
    writeln('--------------------------------------------------------------');
    writeln('               Cafe Kel 2 Struktur Data                       ');
    writeln('               Jalan Raya Tengah No. 80                       ');
    writeln('            Gedong, Pasar Rebo, Jakarta Timur                 ');
    writeln('                 Telp. (021)-78835283                         ');
    writeln('--------------------------------------------------------------');
    writeln('No#      : 01.',tahun,'.',bulan,'.',hari);
    writeln('Tanggal  : ', tahun, '/' , bulan, '/' , hari, ' ', jam, ':', menit);
    writeln('Nama Kasir: ', T.namaKasir);
    writeln('Jenis Pesanan: ', T.jenisPesanan);
    if T.jenisPesanan = 'dine-in' then
        writeln('Nomor Meja: ', T.nomorMeja);
    writeln('--------------------------------');

    Counter := 1;
    Temp := T.head;
    while Temp <> nil do
    begin
        writeln(Counter, '. ', Temp^.namaMenu);
        writeln('   Rp. ', Temp^.harga, ' x ', Temp^.jumlah, ' = Rp. ', Temp^.harga * Temp^.jumlah);
        Temp := Temp^.next;
        Inc(Counter);
    end;
    
    writeln('--------------------------------');
    writeln('Subtotal: Rp ', T.totalHarga); // Diperbaiki: Total menjadi totalHarga
    
    Pajak := round(T.totalHarga * 0.1);
    writeln('Pajak 10%: Rp ', Pajak);
    
    TotalAkhir := HitungTotalAkhir(T.totalHarga);
    
    if TotalAkhir < (T.totalHarga + Pajak) then
    begin
        Diskon := round((T.totalHarga + Pajak) * 0.05);
        writeln('Diskon 5%: Rp ', Diskon);
    end;
    
    writeln('TOTAL AKHIR: Rp ', TotalAkhir);
    writeln('================================');
    writeln('Terima kasih atas kunjungan Anda!');
end;

// Prosedur utama program kasir
var
    NamaKasir, JenisPesanan, NomorMeja, NamaMenu: string;
    Harga: longint;
    Jumlah, Pilihan, NomorPesanan: integer;
    Selesai: boolean;
begin
    clrscr;
    HistoryStack := nil;
    Selesai := false;

    writeln('--------------------------------------------------------------');
    writeln('--------------------------------------------------------------');
    writeln('               Cafe Kel 2 Struktur Data                       ');
    writeln('               Jalan Raya Tengah No. 80                       ');
    writeln('            Gedong, Pasar Rebo, Jakarta Timur                 ');
    writeln('                 Telp. (021)-78835283                         ');
    writeln('--------------------------------------------------------------');
    writeln('--------------------------------------------------------------');

    // Langkah 1: Input nama kasir
    write('Masukkan nama kasir: ');
    readln(NamaKasir);

    // Langkah 2: Input jenis pesanan
    repeat
        write('Masukkan jenis pesanan (dine-in/take-away): ');
        readln(JenisPesanan);
        JenisPesanan := lowercase(JenisPesanan);
    until (JenisPesanan = 'dine-in') or (JenisPesanan = 'take-away');

    // Langkah 3: Input nomor meja jika dine-in
    NomorMeja := '';
    if JenisPesanan = 'dine-in' then
    begin
        write('Masukkan nomor meja: ');
        readln(NomorMeja);
    end;

    // Inisialisasi transaksi
    InisialisasiTransaksi(Transaksi, NamaKasir, JenisPesanan, NomorMeja);

    // Input pesanan ke linked list
    writeln;
    writeln('Masukkan pesanan (ketik "selesai" untuk nama menu jika sudah selesai):');

    repeat
        write('Nama Menu: ');
        readln(NamaMenu); 
        if lowercase(NamaMenu) <> 'selesai' then
        begin
            write('Harga Menu: Rp ');
            readln(Harga);
            write('Jumlah Pesanan: ');
            readln(Jumlah);

            TambahPesanan(Transaksi, NamaMenu, Harga, Jumlah);
            writeln('Pesanan berhasil ditambahkan!');
            writeln;
        end;
    until lowercase(NamaMenu) = 'selesai';

    // Langkah 4: Tampilkan pesanan
    TampilkanPesanan(Transaksi);
    writeln('Tekan enter untuk melanjutkan...');
    readln;

    // Langkah 5: Review dan edit pesanan
    repeat
        clrscr;
        TampilkanPesanan(Transaksi);
        writeln('PILIHAN EDIT:');
        writeln('1. Hapus Pesanan');
        writeln('2. Edit Jumlah Pesanan');
        writeln('3. Selesai Review');
        write('Pilihan Anda (1-3): ');
        readln(Pilihan);
    
        case Pilihan of
        1:
        begin
            write('Masukkan nomor pesanan yang akan dihapus: ');
            readln(NomorPesanan);
            HapusPesanan(Transaksi, NomorPesanan);
            writeln('Tekan enter untuk melanjutkan...');
            readln;
        end;
        2:
        begin
            write('Masukkan nomor pesanan yang akan diedit: ');
            readln(NomorPesanan);
            write('Masukkan jumlah baru: ');
            readln(Jumlah);
            EditJumlahPesanan(Transaksi, NomorPesanan, Jumlah);
            writeln('Tekan enter untuk melanjutkan...');
            readln;
        end;
        3: Selesai := true;
        else
            writeln('Pilihan tidak valid!');
            writeln('Tekan enter untuk melanjutkan...');
            readln;
        end;
    until Selesai;

    // Langkah 6-8: Hitung total dan tampilkan struk akhir
    TampilkanStrukAkhir(Transaksi);

    writeln;
    writeln('Program selesai. Tekan enter untuk keluar...');
    readln;
end.