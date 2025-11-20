select count() from numbers a join numbers b on a.id+2 = b.id;                       
/*23896*/
select count() from numbers a join numbers b on a.id+2 = b.id where a.id and b.id <=1000000;
/*8169*/