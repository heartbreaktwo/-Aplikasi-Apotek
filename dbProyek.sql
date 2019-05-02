--select 'drop table '||tname||' cascade constraint purge;' from tab;

DROP TABLE JENIS CASCADE CONSTRAINT PURGE;
DROP TABLE OBAT CASCADE CONSTRAINT PURGE;
DROP TABLE DETAILRESEP CASCADE CONSTRAINT PURGE;
DROP TABLE PEGAWAI CASCADE CONSTRAINT PURGE;
DROP TABLE CUSTOMER CASCADE CONSTRAINT PURGE;
DROP TABLE HJJUALRESEP CASCADE CONSTRAINT PURGE;
DROP TABLE DOKTER CASCADE CONSTRAINT PURGE;
DROP TABLE HJUALOBAT CASCADE CONSTRAINT PURGE;
DROP TABLE DJUALOBAT CASCADE CONSTRAINT PURGE;


create table JENIS(
    KDJENIS VARCHAR2(3) CONSTRAINT PK_JENIS PRIMARY KEY,
    NMJENIS VARCHAR2(30) CONSTRAINT NN_JENIS NOT NULL
);

CREATE TABLE PEGAWAI(
    KDPEGAWAI VARCHAR2(5) CONSTRAINT PK_PEGAWAI PRIMARY KEY,
    NAMAPEGAWAI VARCHAR2(30),
    USERNAME VARCHAR2(30),
    PASSWORD VARCHAR2(30)
);

CREATE TABLE CUSTOMER(
    KDCUST VARCHAR2(5) CONSTRAINT PK_CUST PRIMARY KEY,
    NAMACUST VARCHAR2(50),
    ALAMATCUST VARCHAR2(50),
    HPCUST VARCHAR2(15),
    UMURCUST NUMBER
);

CREATE TABLE DOKTER(
    KDDOKTER VARCHAR2(5) CONSTRAINT PK_DOKTER PRIMARY KEY,
    NAMADOKTER VARCHAR2(50),
    ALAMATDOKTER VARCHAR2(50),
    HPDOKTER VARCHAR2(15)
);

CREATE TABLE OBAT(
    KDOBAT VARCHAR2(5) CONSTRAINT PK_OBAT PRIMARY KEY,
    KDJENIS VARCHAR2(3),
    CONSTRAINT FK_JENIS
        FOREIGN KEY (KDJENIS)
        REFERENCES JENIS(KDJENIS),
    NAMAOBAT VARCHAR2(40),
    STOKOBAT NUMBER,
    HARGAOBAT NUMBER,
    DESKRIPSIOBAT VARCHAR2(100)
);

CREATE TABLE HJUALOBAT (
    NOJUAL  VARCHAR2(5) CONSTRAINT PK_HJUAL PRIMARY KEY,
    KDPEGAWAI VARCHAR2(5) CONSTRAINT FK_KDPEGAWAI
        REFERENCES PEGAWAI(KDPEGAWAI),
    TGLJUAL DATE,
    TOTALJUAL NUMBER
);

CREATE TABLE DJUALOBAT(
    NOJUAL VARCHAR2(5) CONSTRAINT PK_DJUAL PRIMARY KEY,
    KDOBAT VARCHAR2(5) CONSTRAINT FK_KDOBAT
        REFERENCES OBAT(KDOBAT),
    JUMLAHOBAT  NUMBER,
    HARGAJUALOBAT NUMBER
);

CREATE TABLE HJUALRESEP(
    NORESEP VARCHAR2(5) CONSTRAINT PK_HJUALRESEP PRIMARY KEY,
    KDCUST VARCHAR2(5) CONSTRAINT FK_KDCUSTHJR
        REFERENCES CUSTOMER(KDCUST),
    KDDOKTER VARCHAR2(5) CONSTRAINT FK_DOKTERHJR
        REFERENCES DOKTER(KDDOKTER),
    KDPEGAWAI VARCHAR2(5) CONSTRAINT FK_KDPEGAWAIHJR
        REFERENCES PEGAWAI(KDPEGAWAI),
    TGLRESEP DATE,
    TOTALRESEP NUMBER,
    STATUSKIRIM VARCHAR2(1)
);

CREATE TABLE DETAILRESEP(
    NORESEP VARCHAR2(5),
    CONSTRAINT FK_NORESEPDR 
        FOREIGN KEY (NORESEP)
        REFERENCES HJUALRESEP(NORESEP),
    KDOBAT VARCHAR2(5),
    CONSTRAINT FK_KDOBATDR
        FOREIGN KEY(KDOBAT)
        REFERENCES OBAT(KDOBAT),
    URUTAN NUMBER,
    CONSTRAINT PK_DETAILRESEP
        PRIMARY KEY(NORESEP,KDOBAT,URUTAN),
    JUMLAHPAK NUMBER,
    HARGASATUAN NUMBER,
    CARAMINUM VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER obat_seq_tr
BEFORE INSERT ON obat FOR EACH ROW
DECLARE
	kodemember varchar2(20);
	tempMax number;
BEGIN
	if(instr(:new.namaobat,' ')=0)then
		kodemember:=upper(substr(:new.namaobat,1,2));
	else
		kodemember:=upper(substr(:new.namaobat,1,1))||upper(substr(:new.namaobat,instr(:new.namaobat,' ')+1,1));
	end if;
	select to_number(max(substr(kdobat,-1,3))) into tempMax from obat where kdobat like kodemember||'%';
	if tempMax is null then
		tempMax:=0;
	end if;
	tempMax:=tempMax+1;
	:new.kdobat:=kodemember||lpad(tempMax,3,'0');
END;
/

CREATE OR REPLACE TRIGGER jenis_seq_tr
BEFORE INSERT ON jenis FOR EACH ROW
DECLARE
	kodemember varchar2(20);
	tempMax number;
BEGIN
	if(instr(:new.nmjenis,' ')=0)then
		kodemember:=upper(substr(:new.nmjenis,1,2));
	else
		kodemember:=upper(substr(:new.nmjenis,1,1))||upper(substr(:new.nmjenis,instr(:new.nmjenis,' ')+1,1));
	end if;
	select to_number(max(substr(kdjenis,-1,3))) into tempMax from jenis where kdjenis like kodemember||'%';
	if tempMax is null then
		tempMax:=0;
	end if;
	tempMax:=tempMax+1;
	:new.kdjenis:=kodemember||tempMax;
END;
/

CREATE OR REPLACE TRIGGER dokter_seq_tr
BEFORE INSERT ON dokter FOR EACH ROW
DECLARE
	kodemember varchar2(20);
	tempMax number;
BEGIN
	if(instr(:new.namadokter,' ')=0)then
		kodemember:=upper(substr(:new.namadokter,1,2));
	else
		kodemember:=upper(substr(:new.namadokter,1,1))||upper(substr(:new.namadokter,instr(:new.namadokter,' ')+1,1));
	end if;
	select to_number(max(substr(kddokter,-1,3))) into tempMax from dokter where kddokter like kodemember||'%';
	if tempMax is null then
		tempMax:=0;
	end if;
	tempMax:=tempMax+1;
	:new.kddokter:=kodemember||tempMax;
END;
/
