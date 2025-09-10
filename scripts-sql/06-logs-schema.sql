USE DB_LOGS;
GO

-- Tabela de auditoria geral
CREATE TABLE audit_log (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    service_name NVARCHAR(50) NOT NULL,
    operation NVARCHAR(100) NOT NULL,
    user_id NVARCHAR(50),
    entity_type NVARCHAR(50),
    entity_id NVARCHAR(50),
    old_values NVARCHAR(MAX),
    new_values NVARCHAR(MAX),
    ip_address NVARCHAR(45),
    user_agent NVARCHAR(500),
    correlation_id NVARCHAR(100),
    timestamp DATETIME2 DEFAULT GETDATE()
);

-- Tabela de logs de sistema
CREATE TABLE system_log (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    service_name NVARCHAR(50) NOT NULL,
    log_level NVARCHAR(10) NOT NULL,
    message NVARCHAR(MAX) NOT NULL,
    exception_details NVARCHAR(MAX),
    correlation_id NVARCHAR(100),
    timestamp DATETIME2 DEFAULT GETDATE()
);

-- Índices para performance
CREATE INDEX IX_audit_log_service_timestamp ON audit_log(service_name, timestamp);
CREATE INDEX IX_audit_log_user_timestamp ON audit_log(user_id, timestamp);
CREATE INDEX IX_system_log_service_level_timestamp ON system_log(service_name, log_level, timestamp);
CREATE INDEX IX_audit_log_correlation_id ON audit_log(correlation_id);
CREATE INDEX IX_system_log_correlation_id ON system_log(correlation_id);

GO