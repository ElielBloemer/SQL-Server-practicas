use GD20221C

select dbo.Cliente.* from dbo.Cliente,dbo.Envases where dbo.Cliente.clie_razon_social like 'scifo%'
/*where clie_razon_social like '%a%'*/
select * from dbo.Cliente,dbo.Envases where dbo.Cliente.clie_razon_social like 'scifo%' 

/*NO funciona bien esa Query...*/
 
/*funciona piola desde aca */

select dbo.Cliente.clie_razon_social,COUNT(*) from dbo.Cliente,dbo.Envases where dbo.Cliente.clie_razon_social like 'scifo%' group by dbo.Cliente.clie_razon_social

select dbo.Cliente.clie_razon_social from dbo.Cliente,dbo.Envases 
where dbo.Cliente.clie_razon_social like 'scifo%'
group by dbo.Cliente.clie_razon_social


                              -- Alias   
select clie_vendedor,COUNT(*) cantidad_de_vendedor_por_cliente from Cliente
group by clie_vendedor
having COUNT(clie_vendedor) > 1

--select clie_limite_credito,SUM from Cliente
--group by clie_limite_credito 
--having clie_limite_credito, SUM(*)

select * from Cliente 

select clie_razon_social from Cliente 
order by clie_razon_social desc

select dbo.Envases.* from dbo.Envases

select * from dbo.Familia

select * from dbo.Producto order by prod_precio

select * from Producto

select clie_vendedor, rtrim(empl_apellido)+' '+empl_nombre nombre
from Cliente,Empleado
where clie_vendedor = empl_codigo
group by clie_vendedor,rtrim(empl_apellido)+' '+empl_nombre

/* Ya se puede hacer el ejercicio 1,2 y talvez el 3 */

/*             EJERCICIOS GUIA
  1- Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o 
igual a $ 1000 ordenado por código de cliente
*/
select * from Cliente 

select clie_codigo,clie_razon_social,clie_limite_credito from Cliente
where clie_limite_credito>=1000
order by clie_codigo

/*
                  PRACTICA 
*/
select * from Factura
select * from Item_Factura
select * from Producto

select prod_codigo from Producto,Item_Factura,Factura
where prod_codigo=item_producto
group by prod_codigo
 

 select * from Cliente,Empleado 
 where clie_vendedor=empl_codigo

 /* AMBOS METODOS SON IGUALES */
 select * from Cliente join Empleado on Cliente.clie_vendedor=Empleado.empl_codigo

select clie_razon_social,fact_numero from Cliente,Factura where clie_codigo = fact_cliente

 
select top 2 clie_razon_social,count(*) from cliente left join factura on clie_codigo = fact_cliente
group by clie_razon_social
order by count(*) 

 /*
 2- Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por 
cantidad vendida
*/

/* 1º PRIMERO DEBO DEFINIR EL UNIVERSO */
-- Los productos que fueron vendidos son los que tienen una factura
-- OJO cuando JOINEO 2 tablas, la que tiene mas filas aparece
select prod_codigo,prod_detalle,sum(item_cantidad) from Producto join Item_Factura on prod_codigo = item_producto
                                              join Factura on fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
											  where year(fact_fecha) = 2012
											  group by prod_codigo, prod_detalle
											  order by sum(item_cantidad) DESC


/* 3 - Realizar una consulta que muestre código de producto, nombre de producto y el stock 
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por 
nombre del artículo de menor a mayor.*/
select * from Producto join STOCK on prod_codigo = stoc_producto

select prod_codigo,prod_detalle,isnull(sum(stoc_cantidad),0) cantidad_total from Producto left join STOCK on prod_codigo = stoc_producto
group by prod_codigo,prod_detalle
order by prod_detalle

-- EJEMPLOS DE SELECT DONDE TENGO SUBSELECT DINAMICO Y ESTATICO
-- SUBSELECT DINAMICO(OSEA DEPENDE DE CADA ITERACCION, OSEA DEPENDE DEL EXTERIOR)
select prod_codigo, prod_detalle, isnull((select sum(stoc_cantidad) from stock where prod_codigo=stoc_producto),0) from Producto
group by prod_detalle,prod_codigo

--SUBSELECT ESTATICO(NO DEPENDE DEL EXTERIOR)
select prod_codigo,prod_detalle from Producto join STOCK on prod_codigo=stoc_producto
where prod_codigo in (select stoc_producto from STOCK where stoc_cantidad>0 )
group by prod_detalle,prod_codigo
order by prod_detalle

/*4 - Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de 
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock 
promedio por depósito sea mayor a 100*/  

--Producto
--Componente
--STOCK 
--DEPOSITO

select prod_codigo,prod_detalle,count(comp_cantidad) cantidad_componentes from Producto left join Composicion on prod_codigo = comp_producto
where prod_codigo in (select stoc_producto from STOCK where stoc_cantidad > 1) -- <-- SUBSELECT STATICO
group by prod_codigo,prod_detalle
order by count (comp_cantidad) DESC

select * from Producto left join STOCK on prod_codigo = stoc_producto

select * from Producto left join Composicion on prod_codigo = comp_producto

 -- EJERCICIO 5 

 /*Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de 
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que 
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011*/
-- TABLAS
-- PRODUCTO
-- ITEM FACTURA 
-- FACTURA 

SELECT prod_codigo,prod_detalle,sum(item_cantidad)cantidad_vendida FROM Producto JOIN Item_Factura ON prod_codigo = item_producto
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
where year(fact_fecha) = 2012
group by prod_codigo,prod_detalle
having sum(item_cantidad) > (select sum(item_cantidad) from Item_Factura join Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
where year(fact_fecha) = 2011 and item_producto = prod_codigo)


--EJERCICIO 6
/* Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese 
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que 
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’*/

           --tablas
--RUBRO
--PRODUCTO
--STOCK
--DEPOSITO
SELECT prod_codigo,prod_detalle,rubr_id,SUM(stoc_cantidad)cantidad FROM RUBRO left join Producto ON prod_rubro=rubr_id
                                                        JOIN STOCK ON prod_codigo = stoc_producto
GROUP BY rubr_id,prod_codigo,prod_detalle
HAVING SUM(stoc_cantidad) > (SELECT stoc_cantidad FROM STOCK WHERE stoc_producto = '00000000' AND stoc_deposito = '00')
order by sum(stoc_cantidad) desc
 
--select stoc_cantidad,stoc_producto from STOCK where sum(stoc_cantidad) = '125'