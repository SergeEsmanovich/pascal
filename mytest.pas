program test;
Uses SysUtils;
Type
	DB_Row = Record
	id: Integer;
	text: String;
	height: Real;
	weight: Integer;
	End;
Var
textFile1,textFile2: text;
s,result: string;
myfile: Array[0..100] of DB_Row;
count,i: Integer;
//parser string format
function parse(s:string):DB_Row;
Var
i,n,k:integer;
begin
	n:=1;
	k:=1;
	for i:=1 to length(s) do
	begin
		if s[i]=';' then
		begin
		
		if k = 1 then
		begin
		parse.text:= copy(s,n,i-n);
        n:=i+1;
		end;

		if k = 2 then
		begin
		parse.height:= StrToFloat(copy(s,n,i-n));
        n:=i+1;
		end;

		if k = 3 then
		begin
		parse.weight:= StrToInt(copy(s,n,i-n));
		n:=i+1;
		end;
		
		k:=k+1;
		end;
	end;

end;


//main
begin


	assign(textFile1,'input.txt');
	reset(textFile1);
	i:=0;
	While not eof(textFile1) do
    Begin
    	count:=count+1;
        Readln(textFile1,s);
        Writeln(s);
        myfile[count]:= parse(s);
    End;
    Close(textFile1);
	//Пока не нажата какая то хнень вводить данные
	
	repeat
	begin
    Readln(s);
    count:=count+1;
    if s <> '' then
    if s <> 'end' then
    	begin
    	myfile[count]:= parse(s);
    	s:='';
    	end;
    end;
    until s = 'end';
    
	assign(textFile2,'output.txt');
    rewrite(textFile2);
    for i:= 1 to count do
    begin
      	Writeln(myfile[i].text+' '+FloatToStr(myfile[i].height)+' '+IntToStr(myfile[i].weight));
      	Writeln(textFile2,myfile[i].text+' '+FloatToStr(myfile[i].height)+' '+IntToStr(myfile[i].weight));
    end;
 	Close(textFile2);




end.
