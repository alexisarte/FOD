program ej13pr2;
const
VALOR_ALTO = 32767;
type
    regMaestro = record
        nroUsuario: Integer;
        nombreUsuario: string;
        nombre: string;
        apellido: string;
        cantidadMailEnviados: Integer;
    end;

    regDetalle = record
        nroUsuario: Integer;
        cuentaDestino: string;
        cuerpoMensaje: string;
    end;

    maestro = File of regMaestro;
    detalle = File of regDetalle;

procedure leerArchivo(var archivo: detalle; var reg: regDetalle);
begin
    if (not Eof(archivo)) then begin
        Read(archivo, regDetalle);
    end
    else begin
        reg.nroUsuario:= VALOR_ALTO;
    end;
end;

procedure actualizarMaestro(var maestro1: maestro; var detalle1: detalle); 
var
    regMaestro1: regMaestro;
    regDetalle1: regDetalle;
begin
    Reset(maestro1, regMaestro1);
    Reset(detalle1, regDetalle1);
    leerArchivo(detalle1, regDetalle1);
    while (regDetalle1.nroUsuario <> VALOR_ALTO) do begin
        Read(maestro, regMaestro);
        while (not Eof(maestro1)) do begin
            Read(maestro, regMaestro);
        end;
        while (regMaestro1.nroUsuario = regDetalle1.nroUsuario) do begin
            regMaestro1.cantidadMailEnviados:= regMaestro1.cantidadMailEnviados + 1;
            leerArchivo(detalle1, regDetalle1);
        end;
        Seek(maestro1, FilePos(maestro1) - 1);
        Write(maestro1, regMaestro1);
    end;
    Close(maestro1);
    Close(detalle1);
end;

procedure ExportarInfoDiaD(var maestro1: maestro); 
var
    regMaestro1: regMaestro;
    regDetalle1: regDetalle;
    maestroTxt: Text;
begin
    Assign(maestroTxt, 'infoDiaD.txt');
    Rewrite(maestroTxt);
    Reset(maestro1);
    while (not Eof(maestro1)) do begin
        Read(maestro, regMaestro);
        writeln(maestroTxt, 'nro usuario: ', regMaestro1.nroUsuario, 'cantidadMensajesEnviados: ', regMaestro1.cantidadMailEnviados);
    end;
    Close(maestro1);
    Close(maestroTxt);
end;

var
    maestro1: maestro;
    detalle1: detalle;
begin
    Assign(maestro1, 'logmail.dat');
    Assign(detalle1, 'detalle.dat');
    actualizarMaestro(maestro1, detalle1);
    ExportarInfoDiaD(maestro1);
end.