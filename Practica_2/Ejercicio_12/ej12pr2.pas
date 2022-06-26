program ej12pr2;
const
VALOR_ALTO = 32767;
type
    regAcceso = record
        anio: Integer;
        mes: Integer;
        dia: Integer;
        idUsuario: Integer;
        tiempo: Integer;
    end;

    archivo = File of regAcceso;

procedure leerArchivo(var archivo1: archivo; var acceso: regAcceso);
begin
    if (not Eof(archivo1)) then begin
        Read(archivo1, acceso);
    end
    else begin
        acceso.anio:= VALOR_ALTO;
    end;
end;

procedure mostrarAccesos(var archivo1: archivo; var acceso: regAcceso; anio: Integer);
var
    mesActual, diaActual, usuarioActual: Integer;
    tiempoAnio, tiempoMes, tiempoDia, tiempoUsuario: Real;
begin
    anio:= acceso.anio;
    tiempoAnio:= 0;
    writeln('Anio: ', anio);
    while (acceso.anio = anio) do begin
        mesActual:= acceso.mes;
        tiempoMes:= 0;
        writeln('Mes: ', mesActual);
        while ((acceso.anio = anio) and (acceso.mes = mesActual)) do begin
            diaActual:= acceso.mes;
            tiempoDia:= 0;
            writeln('Dia: ', diaActual);
            while ((acceso.anio = anio) and (acceso.mes = mesActual) and (acceso.dia = diaActual)) do begin
                usuarioActual:= acceso.idUsuario;
                tiempoUsuario:= 0;
                writeln('idUsuario: ', usuarioActual);
                while ((acceso.anio = anio) and (acceso.mes = mesActual) and (acceso.dia = diaActual) and
                        (acceso.idUsuario = usuarioActual)) do begin
                    tiempoUsuario:= tiempoUsuario + acceso.tiempo;
                    leerArchivo(archivo1, acceso);    
                end;
                writeln('Tiempo Total de acceso en el dia', diaActual, 'mes', mesActual, ': ', tiempoUsuario);
                tiempoDia:= tiempoDia + tiempoUsuario;
            end;
            writeln('Tiempo total acceso dia', diaActual, 'mes', mesActual, ': ', tiempoDia);
            tiempoMes:= tiempoMes + tiempoDia;
        end;
        writeln('Total tiempo de acceso mes', mesActual, ': ', tiempoMes);
        tiempoAnio:= tiempoAnio + tiempoMes;
    end;
    writeln('Total tiempo de acceso anio', anio, ': ', tiempoAnio);
end;

procedure buscarAnio(var archivo1: archivo);
var
    anio: Integer;
    acceso: regAcceso;
begin
    write('Ingrese un anio: '); readln(anio);
    Assign(archivo1, 'maestro');
    Reset(archivo1);
    leerArchivo(archivo1, acceso);
    while (acceso.anio <> anio) do begin
        leerArchivo(archivo1, acceso);
    end;
    if (acceso.anio = anio) then begin
        mostrarAccesos(archivo1, acceso, anio);
    end
    else begin 
        writeln('Anio no encontrado');
    end;
    Close(archivo1);
end;

var
    archivo1: maestro;
begin
    Assign(archivo1, 'accesos');
    mostrarAccesos(archivo1);
end.