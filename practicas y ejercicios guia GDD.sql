use GD20221C


select dbo.Cliente.* from dbo.Cliente,dbo.Envases where dbo.Cliente.clie_razon_social like 'scifo%'
/*where clie_razon_social like '%a%'*/
select * from dbo.Cliente,dbo.Envases where dbo.Cliente.clie_razon_social like 'scifo%' 

/*NO funciona bien esa Query...*/
 
/*funciona piola desde aca */

select dbo.Cliente.clie_razon_social,COUNT(*) from dbo.Cliente,dbo.Envases where dbo.Cliente.clie_razon_social like 'scifo%' group by dbo.Cliente.clie_razon_social

select dbo.Cliente.clie_razon_social from dbo.Cliente,dbo.Envases where dbo.Cliente.clie_razon_social like 'scifo%' group by dbo.Cliente.clie_razon_social

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
 