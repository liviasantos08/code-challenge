# Setup do Ambiente com Docker com Embulk e Postgresql

Essas escolhas foram baseadas em experiências anteriores, aproveitando a facilidade de execução de ferramentas com Docker. A escolha do Embulk foi feita devido à familiaridade com sua configuração e à flexibilidade oferecida pelos seus plugins

## Configuração do Ambiente

1. `docker-compose-db.yml`: Banco de dados.
2. `docker-compose-ext.yml`: Extração de dados.
3. `docker-compose-ins.yml`: Inserção de dados no destino.

```bash

# postgres
docker pull postgres

# embulk
docker build -t embulk .


# Banco de dados
docker-compose -f docker-compose-db.yml up -d

# Extração
docker-compose -f docker-compose-ext.yml up -d

# Inserção
docker-compose -f docker-compose-ins.yml up -d


#Lembre-se de garantir que os containers de banco de dados estejam em execução antes dos containers Embulk.


#Listar containers
docker ps -a

# Iniciar container
docker start <container_id ou container_name>
# Exemplo:
# docker start db_inicio
# docker start embulk-orders_ext

## Extração e Inserção de Dados


# Copiar arquivos do container de extração para o host local
docker cp <id-container>:/data/postgres/{table}/{table000.00.csv} /path/to/dados
# Exemplo:
# docker cp 59230e9aeea5:/data/postgres/order_details/order_details.csv /path/to/dados

# E para copiar arquivos para o host local para o container de inserção:
docker cp /path/to/dados <id-container>:/data/postgres/{tabela}/{tabela.csv}
# Exemplo:
# docker cp /path/to/dock-embulk/docker/dados/orders000.00.csv d1277c2c4828:/data/postgres/orders/orders.csv

#Execute os containers de inserção no banco de dados de destino.
docker start embulk-orders_in
docker start orders_detail_in

## Consulta Final
Após a execução de inserção, execute ou copie a query do arquivo consulta-final.sql.

#Se houver erro é possivel verificar os logs de cada extração ou inserção
docker logs -f <container_id ou container_name>
docker logs orders_detail-ext

'''

## Considerações Finais
Apesar do meu projeto inicial ter bucket s3 aws, infelizmente estou com problemas na minha conta aws
e não foi possivel criar um bucket para utilizar como filesystem, mas se fosse possivel dá uma sugestão, recomendaria o bucket s3 para essa situação. 
Por isso foi improvisado com path localhost. 

Para formato de arquivo csv, entendo que é um formato mais fácil de se trabalha além de ser prático. 

Demorei para aprender a instalar o embulk, até que encontrei uma solução com docker. Em cima disso, aprendir a fazer as config.yml embulk e utilizei outros plugins para testes até chegar ao resultado atual. O tempo perdido dificultou para configurar o airflow e extrair os dados de todas as tabelas, além da minha máquina possuir uma configuração basica para o docker que atrapalhou para um funcionamente pleno, inclusive para uma extração de todas as tabelas. Em virtude disso, apenas fiz o necessário do resultado final e as tabelas que realmente importava para este teste.
