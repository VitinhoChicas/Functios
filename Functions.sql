

/* 73.Crie uma função para retornar o número de vendedores cadastrados */
create or replace function ex73Fun()
  returns integer 
  as $$
  declare
  qtd int;
  begin
  	select count(codigo_vendedor) from vendedor into qtd;
	return qtd;
end;
$$
language plpgsql;

select * from ex73Fun();

/*74.Elabore uma função para retornar a quantidade de pedidos que um determinado
vendedor participou.*/

create or replace function ex74Fun()
  returns integer
  as $$
  
  declare 
  qntV int;
  begin
  
select count(codigo_vendedor)from pedido where codigo_vendedor = 101 into qntV;
return qntV;
end;
$$

language plpgsql;

select * from ex74Fun();

/*75.Faça uma função que mostre os vendedores que atenderam um cliente, cujo seu
nome é passado por parâmetro.*/

create or replace function ex75Funt(nome_clienteE varchar)

 returns table(codigo_vendedor integer,  nome_vendedor varchar(40), nome_cliente varchar(40))
			   as $$
			   begin

return query select pd.codigo_vendedor,  vd.nome_vendedor ,cl.nome_cliente from cliente as cl left join pedido as pd
on pd.codigo_cliente = cl.codigo_cliente inner join vendedor as vd 
on vd.codigo_vendedor = pd.codigo_vendedor where cl.nome_cliente = nome_clienteE;
			   
			   end;
			   $$
			   language plpgsql;


select * from ex75Funt('Ana');

/*76.Crie uma função que retorne todos os códigos, nomes e unidades dos produtos
cadastrados.*/

  create or replace function ex76Fun()
   returns table (codigo_produto integer, descricao_produto varchar(30), unidade char(3))
   as $$ 
   begin
   return query select s.codigo_produto, s.descricao_produto, s.unidade from produto as s;
   end; $$
   language plpgsql;

  select * from ex76Fun();
  
  
  /*77.Faça uma função que mostre o maior, o menor e a média de salário dos
vendedores que atenderam uma determinada cliente cujo nome do cliente e faixa
de comissão do vendedor é passado por parâmetro.*/
  
  
CREATE OR REPLACE FUNCTION ex77Fun(
    nome_cliente_param VARCHAR,
    faixa_comissao_param VARCHAR
)
RETURNS TABLE(maior_salario NUMERIC, menor_salario NUMERIC, media_salario NUMERIC)
AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        MAX(vd.salario_fixo) AS maior_salario,
        MIN(vd.salario_fixo) AS menor_salario,
        ROUND(AVG(vd.salario_fixo), 2) AS media_salario
    FROM vendedor AS vd
    INNER JOIN pedido AS pd ON pd.codigo_vendedor = vd.codigo_vendedor
    INNER JOIN cliente AS cl ON cl.codigo_cliente = pd.codigo_cliente
    WHERE cl.nome_cliente = nome_cliente_param
      AND vd.faixa_comissao = faixa_comissao_param;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM ex77Fun('Jorge', 'c');

/*78.Desenvolva uma função que mostre descrição do produto, a quantidade de
produtos vendidos, o Preço Unitário e o total (quantidade*Preço Unitário) de um
determinado Pedido.*/

create or replace function ex78Fun(numeropedido integer)
 returns table(num_pedido integer, descricao_produto varchar(30), quantidade numeric(10,2), val_unit numeric(10,2), total numeric(10,3))
 as $$
 begin

return query select pdi.num_pedido, pd.descricao_produto, idp.quantidade, pd.val_unit, round((idp.quantidade * pd.val_unit),3) as total from produto as pd left join item_do_pedido as idp 
on idp.codigo_produto = pd.codigo_produto left join pedido as pdi 
on pdi.num_pedido = idp.num_pedido where pdi.num_pedido = numeropedido;
END;
$$ LANGUAGE plpgsql;

select * from ex78Fun(97);

/*79.Desenvolva uma função que retorne a soma de uma venda de um determinado
pedido.*/

create or replace function ex79Fun(numeroPedido integer)
 returns table(num_pedido integer, codigo_produto integer, quantidade numeric(10,2), val_unit numeric(10,2), total_venda numeric(10,3))
 as $$
 begin

return query select idp.num_pedido, pd.codigo_produto, idp.quantidade, pd.val_unit, round((idp.quantidade * pd.val_unit),2) as total_venda from item_do_pedido as idp left join produto as pd
on  pd.codigo_produto = idp.codigo_produto where idp.num_pedido = numeroPedido;

end;
$$

language plpgsql;

select * from ex79Fun(121);

/*80.Faça uma função que retorne a quantidade de pedidos que cada vendedor
participou.*/

create or replace function ex80Fun()
 returns table(codigo_vendedor integer, quantidadePedidos integer)
 as $$
 begin
return query select pd.codigo_vendedor,count(pd.num_pedido)::integer as quantidadePedidos from pedido as pd  group by pd.codigo_vendedor;
 end; $$
  language plpgsql;
  
  select * from ex80Fun();
  
/*81.Crie uma função que retorne o código e o nome dos clientes, cujo código do
vendedor, o estado que reside o cliente e o prazo de entrega do pedido seja
passado por parâmetro.*/

create or replace function ex81Fun(cod integer, estado char(2), entrega integer)
 returns table(codigo_cliente integer, nome_cliente varchar(30))
 as $$
 begin
 
return query select cl.codigo_cliente, cl.nome_cliente from cliente as cl  inner join pedido as pd
on pd.codigo_cliente = cl.codigo_cliente where pd.codigo_vendedor = cod and cl.uf = estado and pd.prazo_entrega = entrega
  GROUP BY 
        cl.codigo_cliente, 
        cl.nome_cliente;
 end ; $$
 
 language plpgsql;
 
 select * from ex81Fun(209, 'RJ', 20);