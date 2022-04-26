program ej6pr3;
type
    str50 = string[50];
    
    prenda = record
        codPrenda: Integer;
        descripcion: str50;
        colores: str50;
        stock: Integer;
        precioUnitario: Real;
    end;

    archivoPrendas = File of prenda;
    archivoCodigos = File of Integer;
    
function buscarPrenda(var prendas: archivo; codigo: Integer): Integer;
var
    prenda1: novela; pos: Integer;
begin
    pos:= -1;
    Seek(prendas, 0);
    while ((not eof(prendas)) and (prenda1.codigo <> codigo)) do begin
        read(prendas, prenda1);
    end;
    if (prenda1.codigo = codigo) then begin
        pos:= FilePos(prendas) - 1;
    end;
    buscarPrenda:= pos;
end;

procedure eliminarPrendas(var prendas: archivoPrendas; var codigos: archivoCodigos);
var 
    codigo, pos: Integer;
    prenda1: prenda;
begin
    Reset(codigos);
    Reset(prendas);
    while (not Eof(codigos)) do begin
        Read(codigos, codigo);
        pos:= buscarPrenda(prendas, codigo);
        Seek(prendas, pos);
        Read(prendas, prenda1);
        prenda1.stock:= -1;
        Seek(prendas, pos);
        Write(prendas, prenda1);
        Seek(prendas, 0);
    end;
    Close(codigos);
    Close(prendas);
end;

procedure compactar(var prendas, prendasNuevo: archivoPrendas); 
var 
    prenda1: prenda;
begin
    Rewrite(prendasNuevo);
    Reset(prendas);
    while (not Eof(prendas)) do begin
        Read(prendas, prenda1);
        if (prenda1.stock <> -1) then begin
            Write(prendasNuevo, prenda1);
        end;
    end;
    Close(prendas);
    Close(prendasNuevo);
    Erase(prendas);
    Rename(prendasNuevo, 'indumentaria')
end;

var 
    prendas, prendasNuevo: archivoPrendas;
    codigos: archivoCodigos;
begin
    Assign(prendas, 'indumentaria');
    Assign(prendasNuevo, 'indumentariaNuevo');
    eliminarPrendas(prendas, codigos);
    compactar(prendas, prendasNuevo);
end.