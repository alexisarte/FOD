program ej11pr2;
const
VALOR_ALTO = 'ZZZ';
type
    // str30 = string[30];
    info = record
        nombreProvincia: string;
        cantAlfabetizados: Integer;
        totalEncuestados: Integer;
    end;

    infoDetalle = record
        nombreProvincia: string;
        codLocalidad: Integer;
        cantAlfabetizados: Integer;
        cantEncuestados: Integer;
    end;

    maestro = File of info;
    detalle = File of infoDetalle;

procedure actualizarMaestro(var maestro1: maestro; var detalle1, detalle2: detalle);
    
    procedure leerArchivo(var archivo: detalle; var datos: infoDetalle);
    begin
        if (not Eof(archivo)) then begin
            Read(archivo, datos);
        end
        else begin
            datos.nombreProvincia:= VALOR_ALTO;
        end;
    end;

    procedure minimo(var regDetalle1, regDetalle2: infoDetalle; var detalle1, detalle2: detalle; var min: infoDetalle);
    begin
        if(regDetalle1.nombreProvincia < regDetalle2.nombreProvincia) then begin
            min:= regDetalle1;
            leerArchivo(detalle1, regDetalle1);
        end
        else begin
            min:= regDetalle2;
            leerArchivo(detalle2, regDetalle2);
        end;
    end;

var
    regDetalle1, regDetalle2: infoDetalle;
    min: infoDetalle; regMaestro: info;
begin
    Assign(detalle1, 'detalle1'); Reset(detalle1); leerArchivo(detalle1, regDetalle1);
    Assign(detalle2, 'detalle2'); Reset(detalle2); leerArchivo(detalle2, regDetalle2);
    Assign(maestro1, 'maestro'); Reset(maestro1); 
    minimo(regDetalle1, regDetalle2, detalle1, detalle2, min);
    while (min.nombreProvincia <> VALOR_ALTO) do begin
        Read(maestro1, regMaestro);
        while (regMaestro.nombreProvincia <> min.nombreProvincia) do begin
            Read(maestro1, regMaestro);
        end;
        while (min.nombreProvincia = regMaestro.nombreProvincia) do begin
            regMaestro.cantAlfabetizados:= regMaestro.cantAlfabetizados + min.cantAlfabetizados;
            regMaestro.totalEncuestados:= regMaestro.totalEncuestados + min.cantEncuestados;
            minimo(regDetalle1, regDetalle2, detalle1, detalle2, min);
        end;
        Seek(maestro1, FilePos(maestro1) - 1);
        Write(maestro1, regMaestro);
    end;
    Close(maestro1); Close(detalle1); Close(detalle2);
end;

var
    maestro1: maestro;
    detalle1, detalle2: detalle;
begin
    actualizarMaestro(maestro1, detalle1, detalle2);
end.