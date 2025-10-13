program kelompok2;
uses crt;

type 
    dataS = ^data;
    data = record
    prev: dataS;
    next: dataS;
end;

var 
    input, i, j: integer;
    banyaknya : char;
    nm_masakan : string;
    hrg : longint;
begin
clrscr;
    write('Berapa Banyak jumlah barang yang Ingin Anda Beli? = ');
    readln(input);
    writeln();
    for i := 1 to input do
        begin    
        writeln('Data ke-',i);
        write('Nama Barang : ');
        readln(nm_masakan);
        write('Harga Barang : ');
        readln(hrg);
        write('Jumlah Barang : ');
        readln(banyaknya);
        writeln();
    end;

    writeln('--------------------------------------------------------------');
    writeln('--------------------------------------------------------------');
    writeln('                       Cafe PELER GAJAH                       ');
    writeln('                      jL. HARAPAN BANGSAT                     ');
    writeln('                       HARAPAN PALSU WKWK                     ');
    writeln('                      Telp. 0812345678910                     ');
    writeln('--------------------------------------------------------------');
    writeln('No#      : 01.2018.04.08.0235');
    writeln('Kasir    : Administrator');
    writeln('Tanggal  : 08-04-2018      17.54');
    writeln('No Meja  : 19');
    writeln('--------------------------------------------------------------');
    writeln('Dine-In');
    readln;
end.