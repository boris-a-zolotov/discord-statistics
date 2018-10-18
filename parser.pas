program parser;
(* {"u":1,"t":1537822593434 *)
(* 15 37822 593434 *)

(* All this due to https://dht.chylex.com/ *)

var
	justread : array [1..24] of char;
	datacol : array [0..5, 0..100000] of longint;
	rescheck, towrite : boolean;
	i, j, cyc, curtime, fstchange, lastchange : longint;
	filenm : string;

const divby=60;


(* Является ли данный символ цифрой? *)

function isdigit (c : char) : boolean;
begin;
	isdigit := (ord(c)>=48) and (ord(c)<=57);
end;


(* Возведение 10 в нужную степень *)

function tenpow (n : integer) : longint;
begin;
 	j:=1;
	for cyc:=1 to n do j:=10*j;
	tenpow:=j; 
end;


(* По переменной времени сделать разумное время *)

procedure gettime;
begin;
	curtime:=0;
	for i:=14 to 18 do
		curtime := curtime +
			(ord(justread[i]) - 48) *
				(tenpow(18-i))  
end;


(* Дочитали до момента учёта сообщения *)

procedure checkarray;
begin;
	rescheck :=
		(justread[1] = '{') and (justread[2] = '"') and
		(justread[3] = 'u') and (justread[4] = '"') and
		(justread[5] = ':') and
		(isdigit(justread[6])) and
		(justread[7] = ',') and (justread[8] = '"') and
		(justread[9] = 't') and	(justread[10] = '"') and
		(justread[11] = ':') and
		(isdigit(justread[12])) and (isdigit(justread[13])) and
		(isdigit(justread[14])) and (isdigit(justread[15])) and
		(isdigit(justread[16])) and (isdigit(justread[17])) and
		(isdigit(justread[18])) and (isdigit(justread[19])) and
		(isdigit(justread[20])) and (isdigit(justread[21])) and
		(isdigit(justread[22])) and (isdigit(justread[23])) and
		(isdigit(justread[24]));
end;


(* Продвинуться в чтении на 1 символ *)

procedure proceed;
begin;
	for i:=1 to 23 do justread[i] := justread[i+1];
	read(justread[24]);
end;


(* Чтение журнала *)

begin;

read(filenm);
assign(input, ('in_' + filenm + '.txt'));
reset(input);

for i:=1 to 24 do read(justread[i]); checkarray;

repeat
	proceed; checkarray;
until rescheck;

repeat
	gettime; write(curtime); write('  |  ');
	datacol[(ord(justread[6])-48), curtime] := datacol[(ord(justread[6])-48), curtime]+1;
	repeat
		proceed; checkarray;
	until rescheck or eof;
until eof;


(* Обработка и вывод результатов *)

assign(output, ('res_' + filenm + '.csv'));
rewrite(output);

for i:=0 to 99999 do begin;
	for cyc:=0 to 1 do begin;
		if (datacol[cyc,i]<>0) and (fstchange=0) then fstchange:=i;
		if datacol[cyc,i]<>0 then lastchange:=i;
	end;
end;

for i:=fstchange-1 to lastchange+1 do begin;
	towrite := ((i-lastchange) mod divby = 0);
	for cyc:=0 to 1 do begin;
		datacol[cyc,100000]:=datacol[cyc,100000]+datacol[cyc,i];
		if towrite then begin; write(datacol[cyc,100000]); write(' ;   '); end;
	end;
	if towrite then writeln;
end;

end.
