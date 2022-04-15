program ej2pr2;

type    
    str25 = String[25];
    alumno = record
        codAlumno: Integer;
        apellido: str25;
        nombre: str25;
        cursadas: Integer;
        finales: Integer;
    end;

    alumnoD = record
        codAlumno: Integer;
        estadoMateria: Char;
    end;

    maestro = File of alumno; 
    detalle = File of alumnoD;

procedure leer(var alumnosD: detalle; var dato: alumnoD);
begin
    if (not Eof(alumnosD)) then
        Read(alumnosD, dato)
    else
        dato.codAlumno:= 32767;
end;

procedure importarMaestro(var alumnos: maestro);
var 
    maestro: Text;
    estudiante: alumno;
begin
    Assign(maestro, 'data/Alumnos.txt');
    Rewrite(alumnos);
    Reset(maestro);
    while not eof(maestro) do begin
        Read(maestro, estudiante.codAlumno, estudiante.apellido);
        ReadLn(maestro, estudiante.cursadas, estudiante.finales, estudiante.nombre);
        Write(alumnos, estudiante);
    end;
    Close(alumnos);
    Close(maestro);
end;

procedure importarDetalle(var alumnosD: detalle);
var 
    detalle: Text;
    alumno1: alumnoD;
begin
    Assign(detalle, 'data/AlumnosDetalle.txt');
    Rewrite(alumnosD);
    Reset(detalle);
    while not eof(detalle) do begin
        ReadLn(detalle, alumno1.codAlumno, alumno1.estadoMateria);
        Write(alumnosD, alumno1);
    end;
    Close(alumnosD);
    Close(detalle);
end;

procedure mostrarAlumno(alumno1: alumno);
begin
    WriteLn('Codigo de alumno: ', alumno1.codAlumno);
    WriteLn('Apellido: ', alumno1.apellido);
    WriteLn('Nombre: ', alumno1.nombre);
    WriteLn('Cursadas: ', alumno1.cursadas);
    WriteLn('Finales: ', alumno1.finales);
    WriteLn('------------------------------------------------');
    WriteLn();
end;    

procedure mostrarAlumnoD(alumno1: alumnoD);
begin
    WriteLn('Codigo de alumno: ', alumno1.codAlumno);
    WriteLn('Estado de la materia: ', alumno1.estadoMateria);
    WriteLn('------------------------------------------------');
    WriteLn();
end;

procedure listarAlumnosRegulares(var alumnos: maestro);
var
    alumno1: alumno;
begin
    Reset(alumnos);
    while not eof(alumnos) do begin
        Read(alumnos, alumno1);
        if (alumno1.cursadas > 4) then 
            mostrarAlumno(alumno1);
    end;
    Close(alumnos);
end;

procedure actualizarMaestro(var alumnosM: maestro; var alumnosD: detalle);
var
    registroD: alumnoD; registroM: alumno;
    aux, totalF, totalC: Integer;
begin
    Reset(alumnosM);
    Reset(alumnosD);
    leer(alumnosD, registroD);
    Read(alumnosM, registroM);
    while (registroD.codAlumno <> 32767) do begin
        aux:= registroD.codAlumno;
        totalF:= 0;
        totalC:= 0;
        while (aux = registroD.codAlumno) do begin
            if (registroD.estadoMateria = 'F') then
                totalF:= totalF + 1
            else 
                totalC:= totalC + 1;
            leer(alumnosD, registroD);
        end; 
        while (registroM.codAlumno <> aux) do begin
            Read(alumnosM, registroM);
        end;
        registroM.finales:= registroM.finales + totalF;
        registroM.cursadas:= registroM.cursadas + totalC;
        Seek(alumnosM, FilePos(alumnosM)-1);
        Write(alumnosM, registroM); 
    end;
    Close(alumnosM);
    Close(alumnosD);
end;

var
    alumnosM: maestro; alumnosD: detalle;
begin
    Assign(alumnosM, 'alumnos');
    Assign(alumnosD, 'alumnosDetalle');
    importarMaestro(alumnosM);
    importarDetalle(alumnosD);
    actualizarMaestro(alumnosM, alumnosD);
    listarAlumnosRegulares(alumnosM)
end.