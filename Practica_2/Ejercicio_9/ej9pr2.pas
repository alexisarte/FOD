program ej9pr2;
const
    valorAlto = 32767;
type
    str25 = String[25];

    mesaElectoral = record
        codigoProvincia: Integer;
        codigoLocalidad: Integer;
        nroMesa: Real;
        cantidadVotos: Integer;
    end;

    archivoMaestro = File of mesaElectoral;

procedure importarMaestro(var mesasElectorales: archivoMaestro);
var 
    maestro: Text;
    mesa1: mesaElectoral;
begin
    Assign(maestro, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_9\Mesas_electorales.txt');
    Rewrite(mesasElectorales);
    Reset(maestro);
    while not eof(maestro) do begin
        Read(maestro, mesa1.codigoProvincia, mesa1.codigoLocalidad, mesa1.nroMesa, mesa1.cantidadVotos);
        Write(mesasElectorales, mesa1);
    end;
    Close(mesasElectorales);
    Close(maestro);
end;
    
procedure leer(var archivo: archivoMaestro; var dato: mesaElectoral);
begin
    if (not Eof(archivo)) then
        Read(archivo, dato)
    else
        dato.codigoProvincia:= valorAlto;
end; 

procedure reporte(var mesasElectorales: archivoMaestro);
var
    regMaestro: mesaElectoral;
    codigoProvinciaActual, codigoLocalidadActual: Integer; 
    totalLocalidad, totalProvincia, total: Real;
begin
    Reset(mesasElectorales);
    leer(mesasElectorales, regMaestro);
    total:= 0;
    while (regMaestro.codigoProvincia <> valorAlto)  do begin
        WriteLn('Codigo de Provincia: ', regMaestro.codigoProvincia);
        codigoProvinciaActual:= regMaestro.codigoProvincia;
        totalProvincia:= 0;
        while (codigoProvinciaActual = regMaestro.codigoProvincia) do begin
            Write('Codigo de Localidad: ', regMaestro.codigoLocalidad, '    ');
            codigoLocalidadActual:= regMaestro.codigoLocalidad;
            totalLocalidad:= 0;
            while ((codigoProvinciaActual = regMaestro.codigoProvincia) and (codigoLocalidadActual = regMaestro.codigoProvincia)) do begin
                totalLocalidad:= totalLocalidad + regMaestro.cantidadVotos;
                leer(mesasElectorales, regMaestro);
            end;
            WriteLn('Total de votos: ', totalLocalidad:2:2);
            totalProvincia:= totalProvincia + totalLocalidad;
            WriteLn('.......................  .........................');
            WriteLn();
        end;
        WriteLn('Total de Votos Provincia: ', totalProvincia:2:2);
        total:= total + totalProvincia;
        WriteLn('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
        WriteLn();
    end;
    WriteLn('Total General de Votos: ', total:2:2);
    Close(mesasElectorales);
end;

var
    mesasElectorales: archivoMaestro;
begin
    Assign(mesasElectorales, 'C:\Users\Alexis\FOD\Practica_2\Ejercicio_9\Mesas_electorales');
    importarMaestro(mesasElectorales);
    reporte(mesasElectorales);
end.
