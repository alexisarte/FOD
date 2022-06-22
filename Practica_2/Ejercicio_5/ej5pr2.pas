program ej5pr2;
const
N = 3;
VALOR_ALTO = 3;
type
    str30 = String[30];

    {direccionDetallada = record
        calle: str30;
        nro: str30;
        piso: str30;
        depto: str30;
        ciudad: str30;
    end;} 

    progenitor = record
        nombreYApellido: str30;
        dni: str30;
    end;

    actaDeNacimiento = record
        nro: str30;
        nombreYApellido: str30;
        direccion: str30; 
        matriculaMedico: str30;
        madre: progenitor;
        padre: progenitor;
    end;

    regDeceso = record 
        matriculaMedico: str30;
        fechaYHora: str30;
        lugar: str30;
    end;

    actaDeFallecimiento = record
        nroActaDeNacimiento: str30;
        dni: str30;
        nombreYApellido: str30;
        deceso: regDeceso;
    end;

    regMaestro = record
        datos: actaDeNacimiento;
        estado: str30;
        deceso: regDeceso;
    end;

    maestro = File of regMaestro;
    detalleNacimiento = File of actaDeNacimiento;
    detalleFallecimiento = File of actaDeFallecimiento;

    regNacimientos = array[1..N] of actaDeNacimiento;
    regFallecimientos = array[1..N] of actaDeFallecimiento;

    vNacimientos = array[1..N] of detalleNacimiento;
    vFallecimientos = array[1..N] of detalleFallecimiento;

procedure leerNacimiento(var archivo: detalleNacimiento; reg: actaDeNacimiento);
begin
    if (not eof(archivo)) then begin 
        Read(archivo, reg) 
    end
    else begin 
        reg.nro:= VALOR_ALTO 
    end;
end;

procedure leerFallecimiento(var archivo: detalleNacimiento; reg: actaDeFallecimiento);
begin
    if (not eof(archivo)) then begin 
        Read(archivo, reg) 
    end
    else begin 
        reg.nroActaDeNacimiento:= VALOR_ALTO 
    end;
end;

procedure minimoNacimiento(var nacimientos: vNacimientos; var registros: regNacimientos; var minimo: detalleNacimiento);
var
    i, posMin: Integer;
begin
    for i:= 1 to N do begin
        if (registros[i].nro < minimo.nro) then begin
            posMin:= i;
            minimo:= registros[i]; 
        end;
    end; 
    if (minimio.nro <> VALOR_ALTO) then begin
        leerNacimiento(nacimientos[posMin], registros[posMin]);
    end;
end;

procedure minimoFallecimiento(var fallecimientos: vFallecimientos; var registros: regFallecimientos1; var minimo: detalleNacimiento);
var
    i, posMin: Integer;
begin
    for i:= 1 to N do begin
        if (registros[i].nro < minimo.nro) then begin
            posMin:= i;
            minimo:= registros[i];
        end;
    end; 
    if (minimio.nro <> VALOR_ALTO) then begin
        leerNacimiento(fallecimientos[posMin], registros[posMin]);
    end;
end;

procedure abrirYLeerDetalles(var nacimientos: vNacimientos; var fallecimientos: vFallecimientos; var regNacimientos1: regNacimientos;
var regFallecimientos: regFallecimientos);
begin
    for i:= 1 to N do begin
        Assign(det1, 'actaDeNacimiento' + i ); // nombreArray[i] nombreLogico 
        Assign(det1, 'actaDeFallecimiento' + i ); // nombreArray[i] nombreLogico
        Reset(nacimientos[i]);
        Reset(fallecimientos[i]);
        leerNacimiento(nacimientos[i], regNacimientos[i]);
        leerFallecimiento(fallecimientos[i], regNacimientos[i]);
    end;
end;

procedure crearMaestro(var maestro1: maestro; var nacimientos: vNacimientos; var fallecimientos: vFallecimientos;
var regNacimientos1: regNacimientos; var regFallecimientos: regFallecimientos);
var
    regMaestro1: regMaestro;
    minN: actaDeNacimiento;
    minF: actaDeFallecimiento;
begin
    abrirYLeerDetalles();
    Rewrite(maestro1);
    minimoNacimiento(minN);
    minimoFallecimiento(minF);
    while (minN.nro <> VALOR_ALTO) do begin
        Read(regMaestro1);
        while (regMaestro1.datos.nro <> minN.nro) do begin
            Read(regMaestro1);
        end;
        regMaestro1.datos:= minN;
        if (minN.nro = minF.nro) then begin
            regMaestro1.estado:= muerto;
            regMaestro1.deceso:= minF.deceso;
            minimoFallecimiento(minF);
        end 
        else begin
            regMaestro1.estado:= vivo;
        end;
        Write(maestro1, regMaestro1);
        minimoNacimiento(minN);
    end;
    Close(maestro1);
    for i:= 1 to N do begin
        Close(nacimientos[i]);
        Close(fallecimientos[i]);
    end;
end;

procedure exportarMaestro(var maestro1: maestro);
var
    reg: regMaestro;
    maestroTxt: Text;
begin
    Assign(maestroTxt, 'personas.txt');
    Reset(maestro1);
    Rewrite(maestroTxt);
    while (not Eof(maestro1)) do begin
        Read(maestro1, reg);
        Write(maestro1, 'PARTIDA DE NACIMIENTO: ', reg.datos.nro, ' ', reg.datos.nombreYApellido, ' ', reg.datos.direccion);
        WriteLn(maestro1, ' ', reg.datos.matriculaMedico);
        WriteLn(maestro1, 'MADRE:', reg.datos.madre.nombreYApellido, ' ', reg.datos.madre.dni);
        WriteLn(maestro1, 'PADRE: ', reg.datos.padre.nombreYApellido, ' ', reg.datos.padre.dni);
        WriteLn(maestro1, 'ESTADO ACTUAL: ', reg.estado, ' ', reg.deceso.matriculaMedico, ' ',
            reg.deceso.fechaYHora, ' ', reg.deceso.lugar);
    end;
    Close(maestro1);
    Close(maestroTxt);
end;

var
    maestro1: archivoMaestro;
    nacimientos: vNacimientos;
    fallecimientos: vFallecimientos;
    regNacimientos1: regNacimientos;
    regFallecimientos1: regFallecimientos;
begin
    crearMaestro(maestro1, nacimientos, fallecimientos, regNacimientos1, regFallecimientos1);
    exportarMaestro(maestro);
end.
