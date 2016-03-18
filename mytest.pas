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


procedure printDb(var count:integer; var myfile:Array of DB_Row);
	var 
	i:integer;
	begin
	Writeln('-------------------');
	for i:=1 to count do
		begin
		Writeln(IntToStr(myfile[i].id) +';'+ myfile[i].text +';'+ FloatToStr(myfile[i].height) +';'+ IntToStr(myfile[i].weight));
		end;
	Writeln('-------------------');
	end;


procedure putRow(var count:integer;var myfile:Array of DB_Row);
	var 
	s:string;
	begin
		Writeln('put "end" if you breack process and back to menu');
		While s <> 'end' do
		begin
	    Readln(s);
	    if s <> '' then
	    if s <> 'end' then
	    	begin
	    	count:=count+1;
	    	myfile[count]:= parse(s);
	    	s:='';
	    	end;
	    end;
	end;

procedure putFor(var count:integer;var myfile:Array of DB_Row);
	var
	num,i:integer;
	s:string;
	temp: Array[0..100] of DB_Row;
	begin
		Writeln('put el num:');
		readln(num);
		Writeln('thank you, and put row');
		Readln(s);
		
		for i:=1 to count do
		begin
			if i <= num then
			temp[i] := myfile[i];
			if i = num then
			temp[i+1] := parse(s);
			if i > num then
			temp[i+1] := myfile[i];
		end;

		count:=count+1;
		for i:= 1 to count do
		begin
		myfile[i]:= temp[i];
		myfile[i].id:= i;
		end;		
	end;

// procedure calcDelta(var count, var myfile:Array of DB_Row);
// var
// deltaI,i:Integer;
// deltaF:Real;
// begin
// 	// for i:=1 to count do
// 	// begin
// 	// deltaI:=myfile[i].weight +deltaI;
// 	// deltaF:=myfile[i].height +deltaF;
// 	// end;

// end;	


procedure menu( var count:integer;var myfile:Array of DB_Row);
	var
	s:string;
	temp: Array[0..100] of DB_Row;
	begin
		While s<>'exit' do
		begin
		Writeln('commands: add, put for');
		Writeln('put "exit" for breack');
		Readln(s);
			case s of
			'add': putRow(count,myfile);
			'put for': 
				begin
					putFor(count,myfile);
			 	end;
			// 'deltaH': calcDelta(count,myfile); 	
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
        myfile[count].id:=count; 
    End;
    Close(textFile1);
	//Пока не нажата какая то хнень вводить данные
	
	menu(count,myfile);
	printDb(count,myfile);

	assign(textFile2,'output.txt');
    rewrite(textFile2);
    for i:= 1 to count do
    begin
       	Writeln(textFile2,myfile[i].text+' '+FloatToStr(myfile[i].height)+' '+IntToStr(myfile[i].weight));
    end;
 	Close(textFile2);




end.
