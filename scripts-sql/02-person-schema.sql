USE DB_PESSOA;
GO

-- Tabela de pessoas
CREATE TABLE pessoas (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    tipo_pessoa NVARCHAR(20) NOT NULL CHECK (tipo_pessoa IN ('PROPRIETARIO', 'INQUILINO', 'FIADOR', 'TERCEIRO')),
    nome NVARCHAR(255) NOT NULL,
    cpf_cnpj NVARCHAR(20) NOT NULL UNIQUE,
    rg NVARCHAR(20),
    data_nascimento DATE,
    estado_civil NVARCHAR(20),
    profissao NVARCHAR(100),
    nacionalidade NVARCHAR(50),
    email NVARCHAR(100),
    telefone_principal NVARCHAR(20),
    telefone_secundario NVARCHAR(20),
    endereco_logradouro NVARCHAR(255),
    endereco_numero NVARCHAR(10),
    endereco_complemento NVARCHAR(100),
    endereco_bairro NVARCHAR(100),
    endereco_cidade NVARCHAR(100),
    endereco_estado NVARCHAR(2),
    endereco_cep NVARCHAR(10),
    observacoes NVARCHAR(MAX),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(50),
    updated_by NVARCHAR(50)
);

-- Tabela de documentos anexados
CREATE TABLE pessoa_documentos (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    pessoa_id BIGINT NOT NULL,
    tipo_documento NVARCHAR(50) NOT NULL,
    nome_arquivo NVARCHAR(255) NOT NULL,
    caminho_arquivo NVARCHAR(500) NOT NULL,
    tamanho_arquivo BIGINT,
    content_type NVARCHAR(100),
    created_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(50),
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE
);

-- Índices para performance
CREATE INDEX IX_pessoas_tipo_pessoa ON pessoas(tipo_pessoa);
CREATE INDEX IX_pessoas_cpf_cnpj ON pessoas(cpf_cnpj);
CREATE INDEX IX_pessoas_nome ON pessoas(nome);

GO