drop table modelos cascade constraints;
drop table autocares cascade constraints;
drop table recorridos cascade constraints;
drop table viajes cascade constraints;
drop table tickets cascade constraints;
drop table revisionesModelo cascade constraints;
drop table revisionesAutocar cascade constraints;
drop table conductores cascade constraints;

create table modelos(
 idModelo integer primary key,
 nplazas integer
);

create table revisionesModelo(
 idRevisionM	integer primary key,
 km		        integer not null,
 descripcion  varchar(20),
 idModelo	    integer not null references modelos
 );

create table conductores(
 idConductor integer primary key,
 nombre      	char(20));

create table autocares(
  idAutocar   integer primary key,
  modelo      integer references modelos,
  kms         integer not null,
  idProximaRevision  	integer references revisionesModelo
);

create table recorridos(
   idRecorrido      integer primary key,
   estacionOrigen   varchar(15) not null,
   estacionDestino  varchar(15) not null,
   kms              numeric(6,2) not null,
   horaSalida       timestamp,          --Oracle no tiene time 
   horaLlegada      timestamp not null, --Oracle no tiene time   
   precio           numeric(5,2) not null,
   unique ( estacionOrigen, estacionDestino, horaSalida )   
);

create table viajes(
 idViaje     	integer primary key,
 idAutocar   	integer references autocares  not null,
 idRecorrido 	integer references recorridos not null,
 fecha 		    date not null,
 nPlazasLibres	integer not null,
 --realizado      boolean default false not null,
 realizado      smallint default 0 not null check(realizado in (0,1)),
 idConductor    integer not null references conductores,
 unique (idRecorrido, fecha) 
);

create table tickets(
 idTicket 	integer primary key,
 idViaje  	integer references viajes not null,
 fechaCompra    date not null,
 cantidad       integer not null,
 precio		numeric(5,2) not null
);
drop sequence seq_tickets;
create sequence seq_tickets;

create table revisionesAutocar(
 idRevisionA    integer  primary key,
 idRevisionM    integer not null references revisionesModelo,
 idAutocar	    integer not null references autocares,
 fecha		      date    not null,
 kms		        integer not null,
 UNIQUE ( idRevisionM, idAutocar)
); 

------------------------------------------------
--                                            nPlazas	idModelo 
insert into modelos (idModelo, nPlazas) values ( 1,     40 );  
insert into modelos (idModelo, nPlazas) values ( 2,     15 );  
insert into modelos (idModelo, nPlazas) values ( 3,     35 );  

insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo ) 
		     values                 ( 1,        5000,  'Frenos',  	           1);
insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo ) 
		     values                 ( 2,        10000, 'Frenos y filtros',     1);	
insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo )                 
		     values                 ( 3,        5000,  'Frenos y filtros',     2);	
insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo )                 
		     values                 ( 4,        5000,  'Frenos y filtros',     3);	

insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values
                          (	1,          1,	  1000, 		1); 		
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values
                          (	2,          1,	7500,		    2);
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values          
                          (	3,          2,	2000,		    2);
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values          
                          ( 4,          2,  1000,       2);
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values          
                          ( 5,          3,  1000,       4);     

insert into revisionesAutocar ( idRevisionA, idRevisionM, idAutocar, fecha,	            kms ) 
                        values ( 1,             1,		      2,      trunc(current_date)-365, 	5500);   

                                                   --
insert into conductores( idConductor, nombre ) values (1, 'Pepe');
insert into conductores( idConductor, nombre ) values (2, 'Juan');
insert into conductores( idConductor, nombre ) values (3, 'Ana');

insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 1, 'Burgos',	   'Madrid',	      201,	'1/1/1 8:30',	'1/1/1 10:30',	10 );
insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 2, 'Burgos',	    'Madrid',	      200,	'1/1/1 16:30', '1/1/1 18:30',	12 );

insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 3,  'Madrid',	  'Burgos',	        200,	'1/1/1 13:30',	'1/1/1 15:30',	10 );

insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 4, 'Leon',       'Zamora',       150,    '1/1/1 8:00',  '1/1/1 9:30',    6  );  

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
(	1,        1,		      1,	    DATE '2009-1-22', 30,           1,        1);

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
(	2,        1,		      1,	    trunc(current_date)+1,   38,           0,        2);

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
( 3,      1,              1,    trunc(current_date)+7,   10,         0,        3);

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
( 4,      2,              4,	  trunc(current_date)+7,   40,         0,       1);
	        
		
insert into tickets (	idTicket, idViaje, fechaCompra,	cantidad, precio)  
                  values(	seq_tickets.nextval,        1,	trunc(current_date)-3,	  1,	      10);
insert into tickets (	idTicket, idViaje, fechaCompra,	cantidad, precio)                    
                  values( seq_tickets.nextval,        2,  trunc(current_date)-1, 2,        10);	    
                  
commit;
--exit;

create or replace procedure comprarBillete( arg_hora recorridos.horaSalida%type,
          arg_fecha viajes.fecha%type, arg_origen recorridos.estacionorigen%type,
          arg_destino recorridos.estaciondestino%type, arg_nroPlazas viajes.nplazaslibres%type
) is 

    v_idViaje         viajes.idViaje%type;
    v_precioRecorrido recorridos.precio%type;
    v_numPlazasLibres viajes.nplazaslibres%type;
    v_fechaCompra     date := trunc(sysdate);
    
begin

  -- 1. Consultar el id_viaje, precio del recorrido y plazas libres
    select v.idViaje, r.precio, v.nPlazasLibres
    into v_idViaje, v_precioRecorrido, v_numPlazasLibres
    from viajes v
    join recorridos r on v.idRecorrido = r.idRecorrido
    where v.fecha = arg_fecha
    and r.estacionOrigen = arg_origen
    and r.estacionDestino = arg_destino
    and r.horaSalida = arg_hora;

    -- Verificar si hay suficientes plazas libres
    if v_numPlazasLibres < arg_nroPlazas then
        raise_application_error(-20001, 'Plazas insuficientes. Se solicitaron ' || arg_nroPlazas || ' y solo quedan ' || v_numPlazasLibres);
    end if;

    -- 2. Decrementar el número de plazas libres en la tabla de viajes
    update viajes
    set nPlazasLibres = nPlazasLibres - arg_nroPlazas
    where idViaje = v_idViaje;

    -- 3. Insertar el ticket correspondiente
    insert into tickets (idTicket, idViaje, fechaCompra, cantidad, precio)
    values (seq_tickets.nextval, v_idViaje, v_fechaCompra, arg_nroPlazas, arg_nroPlazas * v_precioRecorrido);

    commit; -- Confirmar la transacción
exception
    when no_data_found then
        raise_application_error(-20002, 'No existe ese viaje para esa fecha, hora, origen y destino.');
    when others then
        raise;
end;
/
		       
create or replace procedure test_comprarBillete is
begin
    -- 1. Comprar un billete para un viaje inexistente
    begin
        comprarBillete('1/1/1 12:00:00', date '2010-04-15', 'Burgos', 'Madrid', 3);
        dbms_output.put_line('Mal no detecta NO_EXISTE_VIAJE.');
    exception
        when others then
            if sqlcode = -20002 then
                dbms_output.put_line('Detecta OK NO_EXISTE_VIAJE: ' || sqlerrm);
            else
                dbms_output.put_line('Mal no detecta NO_EXISTE_VIAJE: ' || sqlerrm);
            end if;
    end;

    -- 2. Comprar un billete de 50 plazas en un viaje que no tiene tantas plazas libres
    begin
        comprarBillete('1/1/1 8:30:00', date '2009-01-22', 'Burgos', 'Madrid', 50);
        dbms_output.put_line('Mal no detecta NO_PLAZAS.');
    exception
        when others then
            if sqlcode = -20001 then
                dbms_output.put_line('Detecta OK NO_PLAZAS: ' || sqlerrm);
            else
                dbms_output.put_line('Mal no detecta NO_PLAZAS: ' || sqlerrm);
            end if;
    end;

    -- 3. Hacemos una compra de un billete de 5 plazas sin problemas
    declare
        varContenidoReal varchar(100);
        varContenidoEsperado varchar(100) := '11122/01/0925113550';
    begin
        comprarBillete('1/1/1 8:30:00', date '2009-01-22', 'Burgos', 'Madrid', 5);

        -- Verificar el contenido de la base de datos después de la compra
        select v.idViaje || v.idAutocar || v.idRecorrido || to_char(v.fecha, 'DD/MM/YY') || v.nPlazasLibres || v.realizado || v.idConductor || t.idTicket || t.cantidad || t.precio
        into varContenidoReal
        from viajes v
        join tickets t on v.idViaje = t.idViaje
        where t.fechaCompra = trunc(sysdate);

        if varContenidoReal = varContenidoEsperado then
            dbms_output.put_line('BIEN: si modifica bien la BD.');
        else
            dbms_output.put_line('Mal: no modifica bien la BD. Real: ' || varContenidoReal || ' Esperado: ' || varContenidoEsperado);
        end if;

    exception
        when others then
            raise;
    end;
end;
/


set serveroutput on
begin
  test_comprarBillete;
end;
