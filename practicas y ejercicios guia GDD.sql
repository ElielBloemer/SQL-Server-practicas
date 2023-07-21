
select * from Cliente 

create table claves (
   id int 
)

insert into claves (id) values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(19)


select id from claves
where id in 
(select top 5 id from claves group by id) or 
id in (select top 5 id from claves group by id order by id desc)

/*nombre del pais, el ultimo campeon mundial que fue por primera vez sin importar la cantidad de titulos */
create table mundial(
  idMundial int primary key identity(1,1),
  anio int not null ,
  paisCampeon varchar(50) not null,
  PaisSubCampeon varchar(50) not null
)

insert into mundial (anio, paisCampeon,PaisSubCampeon) values (1930,'Uruguay','Argentina'),(1934,'Italia','Checoslovaquia'),(1938,'Italia','Hungria'),(1950,'Uruguay','Brasil'),
(1954,'Brasil','Suecia'),(1966,'Inglaterra','Alemania'),(1970,'Brasil','Italia'),(1974,'Alemania','Paises Bajos'),(1978,'Alemania','Paises Bajos'),(1978,'Argentina','Paises Bajos'),(1982,'Italia','Alemania'),
(1986,'Argentina','Alemania'),(1990,'Alemania','Argentina'),(1994,'Brasil','Italia'),(1998,'Francia','Brasil'),(2002,'Brasil','Alemania'),(2006,'Italia','Francia'),(2010,'Espanha','Paises Bajos'),(2014,'Alemania','Argentina'),
(2018,'Francia','Croacia'),(2022,'Argentina','Francia')

select * from mundial 

select m.paisCampeon,count(*) from mundial m
where m.paisCampeon in (select paisCampeon from mundial)
group by m.paisCampeon
--order by m.anio desc


create table mundialFutbol (
idMundial int not null primary key identity (1,1),
anio int not null,
paisCampeon varchar(50) not null,
paisSubCampeon varchar(50) not null
)

insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2022,'argentina','brasil')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2018,'españa','brasil')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2014,'argentina','brasil')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2010,'brasil','alemania')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2006,'alemania','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2002,'alemania','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (1998,'brasil','españa')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (1994,'españa','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (1990,'francia','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (1986,'italia','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2026,'españa','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2030,'argentina','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2032,'españa','argentina')
insert into mundialFutbol (anio, paisCampeon, paisSubCampeon) values (2034,'españa','argentina')

select * from mundialFutbol

create trigger tr_final on mundialFutbol instead of update, insert
 as
 begin transaction
    DECLARE @PAIS VARCHAR(50)
    DECLARE @SUBPAIS VARCHAR (50)
    DECLARE @anio int

    DECLARE cursorParcial CURSOR FOR
    select
        paisCampeon,
        paisSubCampeon,
        anio
    from inserted

    OPEN cursorParcial
    FETCH cursorParcial INTO @PAIS,@SUBPAIS,@anio

    WHILE @@fetch_status = 0
        BEGIN

            IF @PAIS = @SUBPAIS
            begin
                rollback
                print'por pais'
            end
            IF (select top 1 anio from mundialFutbol order by anio desc) < 4
            begin
                rollback
                print'por anio'
            end
            FETCH cursorParcial INTO @PAIS,@SUBPAIS,@anio
        END

    CLOSE cursorParcial
    DEALLOCATE cursorParcial
 commit

 drop trigger tr_final

 /*
  1. Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o 
  igual a $ 1000 ordenado por código de cliente.
*/

select * from Cliente
select clie_codigo,clie_razon_social from cliente
where clie_limite_credito >= 1000
order by clie_codigo desc

/*
2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por 
cantidad vendida.
*/
--,(select year(fac.fact_fecha) from Factura fac where fac.fact_fecha = f.fact_fecha) anio
select * from Item_factura 

select prod_codigo,prod_detalle,sum(item_cantidad) cantidad from Producto p 
left join Item_factura i on i.item_producto = p.prod_codigo 
left join Factura f on f.fact_tipo+f.fact_numero+f.fact_sucursal = i.item_tipo+i.item_numero+i.item_sucursal
where year(f.fact_fecha) = 2012
group by prod_codigo,prod_detalle
order by sum(item_cantidad)


SELECT P.prod_codigo,P.prod_detalle,SUM(IFACT.item_cantidad)
FROM Producto P
INNER JOIN Item_Factura IFACT
	ON IFACT.item_producto = P.prod_codigo
INNER JOIN Factura F
	ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero

WHERE YEAR(F.fact_fecha) = 2012
GROUP BY P.prod_codigo,P.prod_detalle
ORDER BY SUM(IFACT.item_cantidad)

/*------------------------------------------------------------------------------------------------------------------------*/
select * from Factura

/*
3. Realizar una consulta que muestre código de producto, nombre de producto y el stock 
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por 
nombre del artículo de menor a mayor.
*/
--MIO
select p.prod_codigo,p.prod_detalle,sum(stoc_cantidad) stock_total from Producto p
join STOCK s on p.prod_codigo=s.stoc_producto
group by p.prod_codigo,p.prod_detalle  
order by p.prod_detalle asc

--RESUELTO
SELECT P.prod_codigo
		,P.prod_detalle
		,SUM(S.stoc_cantidad)
FROM Producto P
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
	INNER JOIN DEPOSITO D
		ON D.depo_codigo = S.stoc_deposito
GROUP BY P.prod_codigo
		,P.prod_detalle
ORDER BY P.prod_detalle

/*4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de 
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock 
promedio por depósito sea mayor a 100.*/
--MIO
select p.prod_codigo,p.prod_detalle,count(distinct(c.comp_componente)) cant_comp from Producto p 
left join Composicion c on p.prod_codigo=c.comp_producto 
group by p.prod_codigo,p.prod_detalle
having p.prod_codigo in (select s.stoc_producto from STOCK s 
                          group by s.stoc_producto 
						  having avg(s.stoc_cantidad) > 1)
						  order by 3 desc

select * from Composicion 
select * from Producto
select * from STOCK
select count(stoc_producto) from STOCK
select count(distinct stoc_producto) from STOCK
select * from DEPOSITO

--RESUELTO
SELECT P.prod_codigo, P.prod_detalle, COUNT(DISTINCT(C.comp_componente)) AS [Articulos que lo componen], AVG(S.stoc_cantidad)
FROM Producto P
	LEFT OUTER JOIN Composicion C
		ON C.comp_producto = P.prod_codigo
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
	INNER JOIN DEPOSITO D
		ON D.depo_codigo = S.stoc_deposito
GROUP BY P.prod_codigo, P.prod_detalle
HAVING AVG(S.stoc_cantidad) > 100
ORDER BY 3

/*5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de 
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que 
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.*/

select p.prod_codigo,p.prod_detalle,sum(item_cantidad) from Producto p 
left join Item_Factura i  on p.prod_codigo=i.item_producto
left join Factura f on f.fact_tipo+f.fact_numero+f.fact_sucursal = i.item_tipo+i.item_numero+i.item_sucursal
group by p.prod_codigo,p.prod_detalle
having sum(item_cantidad) >= 0

select p.prod_codigo,p.prod_detalle, sum(i.item_cantidad) cantidad_vendida from Producto p 
join Item_Factura i  on p.prod_codigo=i.item_producto
join Factura f on f.fact_tipo+f.fact_numero+f.fact_sucursal = i.item_tipo+i.item_numero+i.item_sucursal
where year(f.fact_fecha) = 2012
group by p.prod_codigo,p.prod_detalle
having sum(i.item_cantidad) > (select top 1 (sum(i1.item_cantidad)) cantidad_vendida from Item_Factura i1 
                                                              join Factura f1 on f1.fact_tipo+f1.fact_numero+f1.fact_sucursal = i1.item_tipo+i1.item_numero+i1.item_sucursal
                                                              where year(f1.fact_fecha) = 2011 and i1.item_producto = p.prod_codigo
															  order by 1 desc)
															  

SELECT P.prod_codigo,P.prod_detalle,SUM(IFACT.item_cantidad)
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON P.prod_codigo = IFACT.item_producto
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
WHERE YEAR(F.fact_fecha) = 2012
GROUP BY P.prod_codigo, P.prod_detalle
HAVING SUM(IFACT.item_cantidad) > (
		SELECT SUM(IFACT2.item_cantidad)
		FROM Item_Factura IFACT2
			INNER JOIN Factura F2
				ON F2.fact_numero = IFACT2.item_numero AND F2.fact_sucursal = IFACT2.item_sucursal AND F2.fact_tipo = IFACT2.item_tipo
		WHERE YEAR(F2.fact_fecha) = 2011 AND IFACT2.item_producto = P.prod_codigo
		)
ORDER BY P.prod_codigo

/*6. Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese 
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que 
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.*/

select * from Rubro
select count(distinct prod_rubro) from Producto

select prod_rubro,count()cantidad_articulos_rubro from Producto
group by prod_rubro

--MIO
select p.prod_rubro,r.rubr_detalle,count(distinct p.prod_codigo) cantidad_articulos_rubro,sum(s.stoc_cantidad) stock_total_rubro from Producto p
right join Rubro r on r.rubr_id=p.prod_rubro
left join STOCK s on p.prod_codigo=s.stoc_producto
where s.stoc_cantidad > (select s1.stoc_cantidad from STOCK s1 where s1.stoc_producto = '00000000' and s1.stoc_deposito = '00')
group by  p.prod_rubro,r.rubr_detalle
order by 1
--having (select s1.stoc_cantidad from STOCK s1 where s1.stoc_producto = '00000000' and s1.stoc_deposito = '00') < sum(s.stoc_cantidad)

--RESUELTO
SELECT R.rubr_id, R.rubr_detalle, COUNT(DISTINCT P.prod_codigo) as [Cantidad de Articulos], SUM(S.stoc_cantidad) AS [Stock Total]
FROM Producto P
	INNER JOIN RUBRO R
		ON R.rubr_id = P.prod_rubro
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
	INNER JOIN DEPOSITO D
		ON D.depo_codigo = S.stoc_deposito
WHERE S.stoc_cantidad > (
		SELECT stoc_cantidad
		FROM STOCK
		WHERE stoc_producto = '00000000'
			AND stoc_deposito = '00'
		)
GROUP BY R.rubr_id,R.rubr_detalle
ORDER BY 1

/*7. Generar una consulta que muestre para cada artículo código, detalle, mayor precio 
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio = 
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean 
stock.
*/

select p.prod_codigo,p.prod_detalle, max(i.item_precio) max_precio, min(i.item_precio) min_precio, 100 - ((min(i.item_precio) / max(i.item_precio))*100) diferencia from Producto p
	  join item_factura i on i.item_producto=p.prod_codigo
	  join STOCK s on s.stoc_producto=p.prod_codigo
where s.stoc_cantidad > 0
group by p.prod_codigo,p.prod_detalle
order by 5 desc 

/*8. Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.*/

--MIO
select p.prod_detalle,p.prod_codigo,count(s.stoc_deposito)cantidad_de_depositos,(select max(s1.stoc_cantidad) from STOCK s1 where s1.stoc_producto = p.prod_codigo) from Producto p
join STOCK s on p.prod_codigo= s.stoc_producto
group by p.prod_detalle,p.prod_codigo
having count(distinct s.stoc_deposito) = (select count(*) from DEPOSITO)

--RESULTO
SELECT P.prod_codigo
		,P.prod_detalle
		,(
			SELECT TOP 1 stoc_cantidad
			FROM STOCK
			WHERE P.prod_codigo = stoc_producto
			ORDER BY stoc_cantidad DESC) AS [Stock del depósito mayor cantidad]
		,count(DISTINCT S.stoc_deposito)
FROM Producto P
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
GROUP BY P.prod_codigo,P.prod_detalle

HAVING (count(DISTINCT S.stoc_deposito)) = (
		SELECT COUNT(depo_codigo)
		FROM DEPOSITO
		)
ORDER BY 1 DESC

/*9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
*/

select e.empl_jefe, e.empl_codigo,e.empl_nombre,count(*) cantidad_depositos
  from Empleado e
  join DEPOSITO d on (d.depo_encargado=e.empl_codigo or d.depo_encargado=e.empl_jefe)
group by e.empl_jefe, e.empl_codigo,e.empl_nombre
