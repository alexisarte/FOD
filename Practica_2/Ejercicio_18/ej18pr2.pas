program ej18pr2;
const
    VALOR_ALTO = 32767;
type
    info = record
        codLocalidad: integer;
        nombreLocalidad: string;
        codMunicipio: integer;
        nombreMunicipio: string;
        codHospital: integer;
        nombreHospital: string;
        fecha: string;
        casosPositivos: integer;
    end;

    archivo = file of reg;

procedure leerArchivo(var arch: archivo; var reg: info);
begin
    if (not Eof(arch)) then
        Read(arch, reg)
    else
        reg.codLocalidad := VALOR_ALTO;
end;

procedure listarInformacion(var arch: archivo);
var
    reg: info;
    archTxt: text;
    localidadActual, municipioActual, hospitalActual: string;
    casosProvincia, casosLocalidad, casosMunicipio, casosHospital: integer;
begin
    Assign(archTxt, 'ej18pr2.txt'); Rewrite(archTxt);   
    casosProvincia:= 0;
    Assign(arch, 'casos.dat'); Reset(arch); leerArchivo(arch, reg); 
    while (reg.codLocalidad <> VALOR_ALTO) do begin //Mientras no se llegue al final del archivo
        casosLocalidad:= 0;
        localidadActual:= reg.nombreLocalidad;
        writeln('Localidad: ', localidadActual);
        while (reg.codLocalidad = localidadActual) do begin 
            casosMunicipio:= 0;
            municipioActual:= reg.nombreMunicipio;
            writeln('Municipio: ', municipioActual);
            while ((reg.codLocalidad = localidadActual) and (reg.codMunicipio = municipioActual)) do begin    
                casosHospital:= 0;
                hospitalActual:= reg.nombreHospital;
                writeln('Hospital: ', hospitalActual);
                while ((reg.codLocalidad = localidadActual) and (reg.codMunicipio = municipioActual) and (reg.codHospital = hospitalActual)) do begin
                    casosHospital:= casosHospital + reg.casosPositivos;
                    leerArchivo(arch, reg);
                end;
                casosMunicipio:= casosMunicipio + casosHospital;
                writeln('Casos en el hospital ', hospitalActual, ': ', casosHospital);
            end;
            if (casosMunicipio > 1500) then begin   
                writeln(archTxt, casosMunicipio, ' ', municipioActual);
                writeln(archTxt, ' ', localidadActual);
            end;
            casosLocalidad:= casosLocalidad + casosMunicipio;
            writeln('Casos en el municipio ', municipioActual, ': ',  casosMunicipio);
        end;
        casosProvincia:= casosProvincia + casosLocalidad;
    end;
    writeln('Casos en la provincia: ', casosProvincia);
    Close(arch); Close(archTxt);    
end;

var
    arch: archivo;
begin
    listarInformacion(arch);
end.