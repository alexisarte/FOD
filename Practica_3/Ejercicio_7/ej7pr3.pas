program ej7pr3;
type 
    str50 = string[50];

    especieDeAve = record
        codigo: Integer;
        nombre: str50;
        familiaDeAve: str50;
        descripcion: str50;
        zonaGeografica: str50;
    end;

    archivoEspecies = File of especieDeAve; 

function buscarEspecie(var especies: archivo; codigo: Integer): Integer;
var
    especie: novela; pos: Integer;
begin
    pos:= -1;
    Seek(especies, 0);
    while ((not eof(especies)) and (especie.codigo <> codigo)) do begin
        read(especies, especie);
    end;
    if (especie.codigo = codigo) then begin
        pos:= FilePos(especies) - 1;
    end;
    buscarEspecie:= pos;
end;

procedure eliminarEspecies(var especies: archivoEspecies);

    procedure bajaLogica(var especies: archivoEspecies);
    var
        pos: Integer;
        especie: especieDeAve;
        especieExtinta: especieDeAve;
    begin
        Write('Ingrese la especie a eliminar:');
        ReadLn(especieExtinta);
        while (not Eof(especies)) do begin
            Read(especies, especie);
            pos:= buscarEspecie(especies, especieExtinta);
            Seek(especies, pos);
            Read(especies, especie);
            especie.codigo:= -1;
            Seek(especies, pos);
            Write(especies, especie);
            Seek(especies, 0);
            Write('Ingrese la especie a eliminar:');
            
            ReadLn(especieExtinta);
        end;
    end;

var 
    especie: especieDeAve;
    pos: Integer;
begin
    Reset(especies);
    Read(especies, especie);
    while (not Eof(especies)) do begin
        pos:= FilePos(especies);
        Read(especies, especie);
        if (especie.codigo = -1) then begin
            Seek(especies, FileSize(especies) - 1);
            Read(especies, especie);
            Seek(especies, pos);
            Write(especies, especie);
            Seek(especies, FileSize(especies) - 1);
            Truncate(especies);
        end;
    end;
    Close(especies);
end;

begin
    
end.