# analise-financas-municipais
Análise das Finanças Municipais de Morada Nova de Minas



Buscaremos puxar todas as informações de receita e despesa da prefeitura de Morada Nova de Minas.

Link das receitas: http://www.adpmnet.com.br/index.php?option=com_contpubl&submenu=1&cnpj=18296665000150&idreg=&tpformtab=jos_coputvcb3&tpformpdf=49&tpform=2&idorg=164&dsorg=Prefeitura%20Municipal%20de%20Morada%20Nova%20de%20Minas&dsufe=Estado%20de%20Minas%20Gerais&brasao=P314350.GIF&titulo=Receitas&idtpc=0&nome_mat=1&nao_proventos=0&nao_descontos=0

Link das despesas: http://www.adpmnet.com.br/index.php?option=com_contpubl&submenu=1&cnpj=18296665000150&idreg=&tpformtab=jos_coputvcb2&tpformpdf=50&tpform=2&idorg=164&dsorg=Prefeitura%20Municipal%20de%20Morada%20Nova%20de%20Minas&dsufe=Estado%20de%20Minas%20Gerais&brasao=P314350.GIF&titulo=Despesas&idtpc=0&nome_mat=1&nao_proventos=0&nao_descontos=0


Primeiro, necessário buscar um código para puxar e estrutura de cada página de cada mês, depois buscar um loop em todos os links.

No script pegando_urls.R, fiz os testes para gerar o loop completo, que inseri no script final loop_url.R

Construída a ferramenta, deverei fazer a mesma extração para as despesas municipais.


*A receita consolidada de Morada foi salva no caminho 'receitas/receita_consolidada_morada.RDS'.*


A lógica de informação das despesas é completamente distinta, devo pensar em algo para compilá-las.