program ej3pr3;
const
MIN = 0;
VALOR_ALTO = 32767; 
type
    str25 = String[25];
  
    novela = record
        codigo: integer;
        genero: str25;
        nombre: str25;
        duracion: Integer;
        director: str25;
        precio: real;
    end;

    archivo = File of novela;

function menu(): integer;
begin
    WriteLn('>>>>>>>>>>>>>>>>>>>> MENU <<<<<<<<<<<<<<<<<<<');
    writeln('Elige una opcion: ');
    writeln('1. Crear archivo');
    writeln('2. Abrir archivo');
    writeln('3. Listar en un archivo de texto todas las novelas');
    writeln('0. Salir');
    writeln();
    readln(menu);
    writeln();
end;

function subMenu(): integer;
begin
    WriteLn('>>>>>>>>>>>>>>>>>>>> SUBMENU <<<<<<<<<<<<<<<<<<<');
    writeln('1. Agregar una novela.');
    writeln('2. Modificar novela.');
    writeln('3. Eliminar novela.');
    writeln('0. Regresar');
    writeln();
    readln(subMenu);
    writeln();
end;

procedure leer(var archivo: archivo; var dato: novela);
begin
    if not Eof(archivo) then begin 
        Read(archivo, dato) 
    end 
    else begin 
        dato.codigo:= VALOR_ALTO;
    end;
end;

procedure leerNovela(var novela1: novela);
begin
    write('Ingrese el codigo de la novela o el numero cero para terminar: '); readln(novela1.codigo);
    if (novela1.codigo <> MIN) then begin
        write('Ingrese el genero: '); readln(novela1.genero);
        writeln('Ingrese el nombre: '); readln(novela1.nombre);
        write('Ingrese la duracion: '); readln(novela1.duracion);
        write('Ingrese el director: '); readln(novela1.director);
        write('Ingrese el precio: '); readln(novela1.precio);
        writeln('=======================================');
    end;
    writeln();
end;

procedure crearNovelas(var novelas: archivo);
var
    novela1: novela;
begin
    rewrite(novelas);
    novela1.codigo:= MIN;
    write(novelas, novela1);
    leerNovela(novela1);
    while (novela1.codigo <> MIN) do begin
        write(novelas, novela1);
        leerNovela(novela1);
    end; 
    close(novelas);
end;

procedure agregarNovela(var novelas: archivo);
var
    novela1, novelaAuxiliar: novela;
    codigo: Integer;
begin
    reset(novelas);
    leer(novelas, novela1);
    codigo:= novela1.codigo;
    if (codigo < 0) then begin  // Si hay espacio libre en el archivo de novelas
        seek(novelas, abs(codigo)); // Voy a ese espacio
        Read(novelas, novelaAuxiliar);  // Me guardo la info del siguiente espacio libre si es que existe  
        seek(novelas, FilePos(novelas) - 1);    // Grabo la info de la novela 
        leerNovela(novela1);                    // en el espacio libre en
        write(novelas, novela1);                // el archivo.    
        seek(novelas, 0);               // Actualizo la lista de
        write(novelas, novelaAuxiliar); // espacio libre.
    end;
    close(novelas);
end;

function buscarNovela(var novelas: archivo; codigo: Integer): Integer;
var
    novela1: novela; pos: Integer;
begin
    pos:= -1;
    while ((not eof(novelas)) and (novela1.codigo <> codigo)) do begin
        read(novelas, novela1);
    end;
    if (novela1.codigo = codigo) then begin
        pos:= FilePos(novelas) - 1;
    end;
    buscarNovela:= pos;
end;

procedure modificarNovela(var novelas: archivo);
var
    novela1: novela; codigo: Integer; pos: Integer;
begin
    write('Ingrese el codigo de la novela que desea modificar: ');
    readln(codigo);
    reset(novelas);
    pos:= buscarNovela(novelas, codigo);
    if (pos <> -1) then begin
        novela1.codigo:= codigo;
        WriteLn('Ingrese los nuevos datos: ');
        write('Ingrese el genero: '); readln(novela1.genero);
        write('Ingrese el nombre: '); readln(novela1.nombre);
        write('Ingrese la duracion: '); readln(novela1.duracion);
        write('Ingrese el director: '); readln(novela1.director);
        write('Ingrese el precio: '); readln(novela1.precio);
        writeln('=======================================');
        seek(novelas, pos); 
        write(novelas, novela1);
        WriteLn('Novela modificada con exito') 
    end
    else begin 
        WriteLn('Novela no encontrada');
    end;
    WriteLn();
    close(novelas);
end;

procedure eliminarNovela(var novelas: archivo);
var
    novelaAuxiliar, novela1: novela; pos, codigo: Integer;
begin
    write('Ingrese el codigo de la novela a eliminar: ');
    readln(codigo);
    reset(novelas);
    leer(novelas, novelaAuxiliar);
    pos:= buscarNovela(novelas, codigo);
    if (pos <> -1) then begin
        Seek(novelas, pos);
        read(novelas, novela1);
        novela1.codigo:= pos * -1;
        Seek(novelas, pos);
        Write(novelas, novelaAuxiliar);
        seek(novelas, 0); 
        Write(novelas, novela1);
        WriteLn('Novela eliminada con exito') 
    end
    else begin
        WriteLn('ERROR: la novela no existe');
    end;
    Close(novelas);
    WriteLn();
end;

procedure exportar(var novelas: archivo);
var
    novela1: novela; novelasTxt: Text;
begin
    assign(novelasTxt, 'novelas.txt'); 
    rewrite(novelasTxt);
    reset(novelas);
    read(novelas, novela1);
    while not eof(novelas) do begin
        read(novelas, novela1);
        if (novela1.codigo > 0) then begin
            writeln(novelasTxt, 'Codigo de novela: ', novela1.codigo, '  Genero: ', novela1.genero, '   Nombre: ', novela1.nombre, '  Duracion: ',
                novela1.duracion, '  Director: ', novela1.director, '  Precio: ',novela1.precio:2:2);
        end
        else begin 
            WriteLn(novelasTxt, 'ESPACIO LIBRE') 
        end;
    end;
    close(novelasTxt);
    close(novelas);
end;

var
    opcion, subOpcion: integer;
    nombreFisico: String[25];
    novelas: archivo;
begin
    write('Ingrese el nombre del archivo a crear o utilizar: ');
    readln(nombreFisico);
    assign(novelas, nombreFisico);
    writeln();
    repeat
        opcion:= menu();
        case opcion of 
            1: begin crearNovelas(novelas); end;
            2: begin
                subOpcion:= submenu();  
                while (subOpcion <> 0) do begin
                    case subOpcion of
                        1: begin agregarNovela(novelas) end;
                        2: begin modificarNovela(novelas) end;
                        3: begin eliminarNovela(novelas) end;
                        else begin writeln('Opcion no reconocida');
                            writeln();
                        end;
                    end;
                    subOpcion:= submenu();
                end;
            end;
            3: begin exportar(novelas) end;
            0: begin writeln('Hasta pronto!') end
            else begin writeln('Opcion no reconocida');
                writeln();
            end;
        end;
    until(opcion = 0);
end.