create or replace procedure FIND_AGNACC_LASTCODE
(
  COMPANY   in number,
  AGNRN     in number,
  STRCODE  out varchar2,
  AGNNAME  out varchar2
)
as
  nAGNRN   PKG_STD.tREF := AGNRN;
  sSTRCODE AGNACC.STRCODE%TYPE;
  sAGNNAME AGNLIST.AGNNAME%TYPE;
  nMAXRN   PKG_STD.tREF;
begin
  /* поиск наименования контрагента */
  begin
    select AGNNAME
      into sAGNNAME
      from AGNLIST A
      where RN = nAGNRN;
  exception
    when NO_DATA_FOUND then
      sAGNNAME := null;
  end;

  /* поиск последнего кода строки */
  sSTRCODE := null;

  select max(RN)
    into nMAXRN
    from AGNACC
    where AGNRN = nAGNRN;

  if nMAXRN is not null then
    begin
      select STRCODE
        into sSTRCODE
        from AGNACC
        where RN = nMAXRN;
    exception
      when NO_DATA_FOUND then
        sSTRCODE := null;
    end;
  end if;
  
  /* Для ТЕЛ МТК - по умолчанию Преодол*/
  if nAGNRN = 33383 then
    select STRCODE
      into sSTRCODE
      from AGNACC
      where RN = 5055348;
  end if;
    

  /* установка результата */
  STRCODE := sSTRCODE;
  AGNNAME := sAGNNAME;
end;
/
