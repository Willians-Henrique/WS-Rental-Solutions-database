#!/bin/bash

# Carregar variáveis de ambiente do arquivo .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Aguardar o banco de dados estar online
while ! nc -z db-ws-solutions 1433; do
    echo "Aguardando o banco de dados estar online..."
    sleep 1
done

echo "Porta 1433 está aberta. Aguardando SQL Server ficar pronto..."
sleep 10

# Aguardar SQL Server estar completamente pronto
until /opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1; do
    echo "Aguardando SQL Server aceitar conexões..."
    sleep 2
done

echo "SQL Server está pronto! Verificando se o banco existe..."

# Verificar se o banco existe
DB_EXISTS=$(/opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT name FROM sys.databases WHERE name = 'DB_WS_IMOB'" -h -1 | grep DB_WS_IMOB)

if [ -z "$DB_EXISTS" ]; then
  echo "Banco de dados não existe. Criando..."
  /opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" -Q "CREATE DATABASE DB_WS_IMOB;"
  /opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" -d DB_WS_IMOB -i /scripts-sql/SQLCreate.sql
  #/opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" -d DB_WS_IMOB -i /WS-Retail-Solutions-database/scripts/02_insert.sql
  #/opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" -d DB_WS_IMOB -i /WS-Retail-Solutions-database/scripts/03_views.sql

else
  echo "Banco de dados já existe. Nenhuma ação necessária."
fi