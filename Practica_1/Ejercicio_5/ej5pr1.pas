program ej5Pr1;
type
  str25 = String[25];

  celular = record
    codigo: integer;
    precio: integer;
    marca: str25; 
    stockMinimo: Integer;
    stockDisponible: Integer;
    descripcion: str25;
    nombre: str25;
  end;
  
  archivo = file of celular;

function menu(): integer;
begin
  writeln('Elige una opcion: ');
  writeln('1. Crear archivo');
  writeln('2. Abrir archivo');
  writeln('0. Salir');
  writeln();
  readln(menu);
  writeln();
end;

function subMenu(): integer;
begin
  writeln('1. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo.');
  writeln('2. Listar en pantalla los celulares cuya descripcion contenga una o varias palabras proporcionada por usted.');
  writeln('3. Exportar el contenido del archivo a un archivo de texto');
  writeln('0. Regresar');
  writeln();
  readln(subMenu);
  writeln();
end;

procedure mostrarCelular(cel: celular);
begin
  with cel do begin 
    write('Codigo: ', codigo, '  ');
    write('Precio: ', precio, '  ');
    write('Marca:', marca, '  ');
    write('Stock Minimo: ', stockMinimo, '  ');
    write('Stock Disponible: ', stockDisponible, '  ');
    write('Descripcion:', descripcion, '  ');
    writeln('Nombre: ', nombre, '  '); 
  end;
end;

procedure crearCelulares(var celulares: archivo);
var
  cel: celular;
  celulares2: Text;
begin
  assign(celulares2, 'Celulares.txt');
  rewrite(celulares);
  reset(celulares2);
  while not eof(celulares2) do begin 
    readln(celulares2, cel.codigo, cel.precio, cel.marca);
    readln(celulares2, cel.stockMinimo, cel.stockDisponible, cel.descripcion);
    readln(celulares2, cel.nombre);
    write(celulares, cel);
  end; 
  close(celulares);
  close(celulares2);
end;

procedure listarCelularesConStockMenor(var celulares: archivo);
var
  cel: celular;
begin
  reset(celulares);
  while not eof (celulares) do begin
    read(celulares, cel);
    if (cel.stockDisponible < cel.stockMinimo) then begin
      mostrarCelular(cel);  
    end;
  end;
  close(celulares);
  writeln();
end;

procedure listarCelularesEspecificos(var celulares: archivo);
var
  cel: celular; desc: str25;
begin
  write('Ingrese el texto que desea filtrar: ');
  readln(desc);
  writeln();
  reset(celulares);
  while not eof (celulares) do begin
    read(celulares, cel);
    if (Pos(desc, cel.descripcion) <> 0) then begin
      mostrarCelular(cel);
    end;
  end;
  close(celulares);
  writeln();
end;

procedure exportar(var celulares: archivo);
var
  celu: celular; texto: Text;
begin
  assign(texto, 'data/Celulares2.txt');
  rewrite(texto);
  reset(celulares);
  while not eof(celulares) do begin
    read(celulares, celu);
    writeln(texto, celu.codigo, ' ', celu.precio, ' ', celu.marca);
    writeln(texto, celu.stockMinimo, ' ', celu.stockDisponible, ' ', celu.descripcion);
    writeln(texto, celu.nombre);
  end;
  close(texto);
  close(celulares);
end;

var
  opcion, subOpcion: integer;
  nombreFisico: String[25];
  celulares: archivo;
begin
  write('Ingrese el nombre del archivo a crear o utilizar: ');
  readln(nombreFisico);
  assign(celulares, nombreFisico);
  writeln();
  repeat
    opcion:= menu();
    case opcion of 
      1: crearCelulares(celulares);
      2: begin
        subOpcion:= submenu();
        while (subOpcion <> 0) do begin
          case subOpcion of
            1: listarCelularesConStockMenor(celulares);
            2: listarCelularesEspecificos(celulares);
            3: exportar(celulares);
            else begin writeln('Opcion no reconocida');
              writeln();
            end;
          end;
          subOpcion:= submenu();
        end;
      end;
      0: writeln('Hasta pronto!')
      else begin writeln('Opcion no reconocida');
        writeln();
      end;
    end;
  until(opcion = 0);
end.