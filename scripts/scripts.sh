#!/bin/bash

# Carregar variáveis de ambiente do arquivo .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Definir bancos de dados dos microserviços
declare -a DATABASES=(
    "DB_AUTH"
    "DB_PERSON"
    "DB_PROPERTY"
    "DB_CONTRACT"
    "DB_FINANCIAL"
    "DB_LOGS"
)

# Definir scripts SQL correspondentes
declare -A DATABASE_SCRIPTS=(
    ["DB_AUTH"]="01-auth-schema.sql"
    ["DB_PERSON"]="02-person-schema.sql"
    ["DB_PROPERTY"]="03-property-schema.sql"
    ["DB_CONTRACT"]="04-contract-schema.sql"
    ["DB_FINANCIAL"]="05-financial-schema.sql"
    ["DB_LOGS"]="06-logs-schema.sql"
)

# Função para aguardar SQL Server ficar pronto
wait_for_sqlserver() {
    echo "Aguardando SQL Server estar online..."
    
    # Aguardar porta estar disponível
    while ! nc -z db-ws-solutions 1433; do
        echo "Aguardando o banco de dados estar online..."
        sleep 1
    done

    echo "Porta 1433 está aberta. Aguardando SQL Server ficar pronto..."
    sleep 10

    # Aguardar SQL Server aceitar conexões
    until /opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1; do
        echo "Aguardando SQL Server aceitar conexões..."
        sleep 2
    done

    echo "SQL Server está pronto!"
}

# Função para verificar se banco existe
database_exists() {
    local db_name=$1
    local result=$(/opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" \
        -Q "SELECT name FROM sys.databases WHERE name = '$db_name'" -h -1 2>/dev/null | grep -w "$db_name")
    
    if [ -n "$result" ]; then
        return 0  # Banco existe
    else
        return 1  # Banco não existe
    fi
}

# Função para criar banco de dados
create_database() {
    local db_name=$1
    local script_file=$2
    
    echo "Criando banco de dados: $db_name"
    
    # Criar banco
    /opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" \
        -Q "CREATE DATABASE [$db_name];" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Banco $db_name criado com sucesso!"
        
        # Executar script de schema se existir
        if [ -f "/scripts-sql/$script_file" ]; then
            echo "Executando script de schema: $script_file"
            /opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" \
                -d "$db_name" -i "/scripts-sql/$script_file" 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo "✅ Schema do $db_name aplicado com sucesso!"
            else
                echo "❌ Erro ao aplicar schema do $db_name"
            fi
        else
            echo "⚠️  Script $script_file não encontrado"
        fi
    else
        echo "❌ Erro ao criar banco $db_name"
    fi
}

# Função principal
main() {
    echo "🚀 Iniciando configuração dos bancos de dados..."
    
    # Aguardar SQL Server
    wait_for_sqlserver
    
    # Verificar e criar cada banco
    for db_name in "${DATABASES[@]}"; do
        echo ""
        echo "📋 Verificando banco: $db_name"
        
        if database_exists "$db_name"; then
            echo "✅ Banco $db_name já existe. Nenhuma ação necessária."
        else
            echo "❌ Banco $db_name não existe."
            script_file="${DATABASE_SCRIPTS[$db_name]}"
            create_database "$db_name" "$script_file"
        fi
    done
    
    echo ""
    echo "🎉 Configuração dos bancos de dados concluída!"
    
    # Listar bancos criados
    echo ""
    echo "📊 Bancos de dados disponíveis:"
    /opt/mssql-tools/bin/sqlcmd -S db-ws-solutions -U sa -P "$MSSQL_SA_PASSWORD" \
        -Q "SELECT name FROM sys.databases WHERE name LIKE 'DB_%'" -h -1 2>/dev/null
}

# Executar função principal
main