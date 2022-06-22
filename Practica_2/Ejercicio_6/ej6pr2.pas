program ej6pr2;
const
MUNICIPIOS = 10;
VALOR_ALTO = 32767;
type
    str30 = string[30]; 

    regCasosCovid = record
        activos: Integer;
        nuevos: Integer;
    end; 

    infoMunicipio = record
        codLocalidad: Integer;
        codCepa: Integer;
        casosCovid: regCasosCovid;
        recuperados: Integer;
        fallecidos: Integer;
    end;

    infoMinisterio = record
        codLocalidad: Integer;
        nombreLocalidad: Integer;
        codCepa: Integer;
        nombreCepa: str30;
        casosCovid: regCasosCovid;
        recuperados: Integer;
        fallecidos: Integer;
    end;

    archivoMaestro = File of infoMinisterio;
    detalle = File of infoMunicipio;

    vDetalles = array[1..MUNICIPIOS] of detalle;
    regDetalles = array[1..MUNICIPIOS] of infoMunicipio;

procedure leerArchivo(var archivo: detalle; var reg: infoMunicipio);
begin
    if (not Eof(archivo)) then begin
        Read(archivo, reg);
    end
    else begin
        reg.codLocalidad:= VALOR_ALTO;
    end;
end;

procedure actualizarMaestro(var maestro: archivoMaestro; var detalles: vDetalles; var regDetalles1: regDetalles);
    
    procedure abrirYLeerDetalles(var detalles: vDetalles; var regDetalles1: regDetalles);
    var
        i: Integer; 
        iStr: string;
    begin
        for i:= 1 to MUNICIPIOS do begin
            Str(i, iStr);
            Assign(detalles[i], 'detalle' + iStr);
            Reset(detalles[i]);
            leerArchivo(detalles[i], regDetalles1[i]);
        end;
    end;

    procedure minimo(var detalles: vDetalles; var regDetalles1: regDetalles; var min: infoMunicipio);
    var
        i, posMin: Integer;
    begin
        posMin:= -1;
        for i:= 1 to MUNICIPIOS do begin
            if ((regDetalles1[i].codLocalidad < min.codLocalidad) or ((regDetalles1[i].codLocalidad = min.codLocalidad) and
                (regDetalles1[i].codCepa < min.codCepa))) then begin
                min:= regDetalles1[i];
            end;
        end;
        if (min.codLocalidad <> VALOR_ALTO) then begin
            leerArchivo(detalles[posMin], regDetalles1[posMin]);
        end;
    end;

var
    regMaestro: infoMinisterio;
    min: infoMunicipio;
begin
    abrirYLeerDetalles(detalles, regDetalles1);
    Reset(maestro);
    minimo(detalles, regDetalles1, min);
    while (min.codLocalidad <> VALOR_ALTO) do begin
        Read(maestro, regMaestro);
        while (regMaestro.codLocalidad = min.codLocalidad) do begin
            while ((regMaestro.codLocalidad <> min.codLocalidad) or (regMaestro.codCepa <> min.codCepa)) do begin
                Read(maestro, regMaestro);
            end;
            while ((regMaestro.codLocalidad = min.codLocalidad) and (regMaestro.codCepa = min.codCepa)) do begin
                regMaestro.fallecidos:= regMaestro.fallecidos + min.fallecidos;
                regMaestro.recuperados:= regMaestro.recuperados + min.recuperados;
                regMaestro.casosCovid.activos:= min.casosCovid.activos;
                regMaestro.casosCovid.nuevos:= min.casosCovid.nuevos; 
                minimo(detalles, regDetalles1, min);
            end;
            Seek(maestro, FilePos(maestro) - 1);
            Write(maestro, regMaestro);
        end;
    end;
    Close(maestro);
    for i:= 1 to MUNICIPIOS do begin
        Close(detalles[i]);
    end;
end;

procedure recorrerArchivo(var maestro: archivoMaestro);
var
    regMaestro: infoMinisterio;
    localidades: Integer;
begin
    Reset(maestro);
    Read(maestro, regMaestro);
    while not Eof(maestro) do begin
        if (regMaestro.casosCovid.activos > 50) then begin
            localidades:= localidades + 1;
        end;
        Read(maestro, regMaestro);
    end;
    Close(maestro);
    writeln('Cantidad de localidades con más de 50 casos activos: ', localidades);
end;

var
    maestro: archivoMaestro;
    detalles: vDetalles;
    regDetalles1: regDetalles;
begin
    Assign(maestro, 'maestro');
    actualizarMaestro(archivoMaestro, detalles, regDetalles1);
    recorrerArchivo(maestro);
end.