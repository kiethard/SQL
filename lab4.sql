CREATE TABLE SACH
(
	masach VARCHAR(255) PRIMARY KEY,
	tensach VARCHAR(255),
	nhaxuatban VARCHAR(255),
	tacgia VARCHAR(255),
	soluong INT
);

CREATE TABLE DOCGIA
(
	madg VARCHAR(30) PRIMARY KEY,
	tendg NVARCHAR(255),
	ngaydk DATE,
	dienthoai INT
);

CREATE TABLE PHIEUMUON
(
	madg VARCHAR(30),
	masach VARCHAR(255),
	ngaymuon DATE PRIMARY KEY,
	ngaytra DATE,
	FOREIGN KEY(madg) REFERENCES DOCGIA(madg),
	FOREIGN KEY(masach) REFERENCES SACH(masach), 
);

INSERT INTO SACH 
VALUES
('B01', N'Doraemon', N'Kim Đồng', N'Fujio', 1024),
('B02', N'Conan', N'Anh Mai', N'Aoyama', 256),
('B03', N'Pokemon', N'Kim Đồng', N'Satoshi', 2048),
('B04', N'Dragon Ball', N'Kim Đồng', N'Toriyama', 512),
('B05', N'Lập Trình Hướng Đối Tượng', N'Văn Ngọc', N'Alexander', 3096)

INSERT INTO DOCGIA
VALUES
('R01', N'Võ Trần Nhật Huy', '2023-01-01', '0971540974'),
('R02', N'Hồ Thị Mỹ Hạnh', '2022-10-25', '0336283829'),
('R03', N'Trần Ngọc Thảo Như', '2014-03-04', '0293847199'),
('R04', N'Lý Mai Hương', '2016-06-06', '0999999999'),
('R05', N'Huỳnh Lê Quang', '2019-10-10', '0888888888')

INSERT INTO PHIEUMUON VALUES
('R01', 'B01', '2023-01-03', '2023-02-03'),
('R04', 'B03', '2022-03-03', '2022-04-03'),
('R03', 'B02', '2020-01-03', '2020-04-03'),
('R05', 'B01', '2023-05-03', '2023-05-06'),
('R01', 'B03', '2023-06-03', '2023-08-03')

--2
SELECT COUNT(DISTINCT nhaxuatban)  AS soluong
FROM SACH;

--3
SELECT masach, tensach FROM SACH
WHERE TENSACH LIKE N'%Lập Trình%'

--4
SELECT * FROM SACH
WHERE masach IN (
    SELECT masach
    FROM PHIEUMUON
    WHERE CONVERT(DATE, ngaymuon) = CONVERT(DATE, GETDATE())
)

--5

SELECT nhaxuatban, COUNT(*) AS SOLUONGSACH FROM SACH
GROUP BY nhaxuatban

--6
SELECT tacgia, COUNT(*) AS SOLUONGSACH FROM SACH
GROUP BY tacgia

--7

SELECT * FROM DOCGIA
WHERE ngaydk=CONVERT(DATE,GETDATE());

--8
SELECT DISTINCT * FROM DOCGIA R, PHIEUMUON T
WHERE R.madg=T.madg
AND YEAR(ngaytra) - YEAR(ngaymuon)<=10
AND MONTH(ngaytra) - MONTH(ngaymuon)=0

--9
select * from DOCGIA where madg in 
(select madg from(select madg,count(*) as SoLanTreHen from PHIEUMUON where ABS(DATEDIFF(day,ngaymuon,ngaytra)) > 1400 
group by madg having count(*) > 3 ) as subquery)
--10
select * from SACH where masach not in (select masach from PHIEUMUON)
--11
select * from SACH where masach in
(select TOP 1 masach from PhieuMuon where year(NgayMuon) = 8 
group by MaSach);
--12
insert into SACH VALUES('9L2',N'Tri giác',N'Lao Động',N'Nguyễn Hữu Nhật',90)
--13
update SACH set soluong = 5 where nhaxuatban like N'Lao Động';
--14
delete from SACH where tacgia like 'nqt';
--15
delete from DOCGIA where ABS(DATEDIFF(day,ngaydk,getDate())) > 1400

Create view VCau3_1 as
Select * from SACH where TacGia like N'%Phước%'

Create view VCau3_2 as
Select * from DocGia where DienThoai = ''

Create view VCau3_3 as
Select * from Sach where MaSach in
(Select MaSach from PhieuMuon  group by PhieuMuon.MaSach
Having count(Masach) >=3)

Create view VCau3_4 as
Select * from Sach where MaSach in
(Select top 1 count(MaSach) from PhieuMuon group by PhieuMuon.MaSach)

Create view VCau3_5 as
select * from DocGia where year(getDate()) - year(NgayDK) > 4

Create view VCau3_6 as
Select * from SACH where soluong = (select MAX(soluong) from SACH);

Create view VCau3_7 as
SELECT SACH.masach, tensach, COUNT(*) AS solanmuon
FROM PHIEUMUON
JOIN SACH ON PHIEUMUON.masach = SACH.masach
GROUP BY SACH.masach, tensach
ORDER BY solanmuon DESC
LIMIT 1;

Create view VCau3_8 as
SELECT DOCGIA.*
FROM DOCGIA
WHERE madg IN (
    SELECT madg
    FROM PHIEUMUON
    GROUP BY madg
    HAVING COUNT(*) > 10
    AND SUM(CASE WHEN ngaytra <= ngaymuon THEN 1 ELSE 0 END) = 0
);


Select * from VCau3_1
Select * from VCau3_2
Select * from VCau3_3
Select * from VCau3_4
Select * from VCau3_5