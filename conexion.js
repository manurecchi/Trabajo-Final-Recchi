const sql = require('mssql');

// Configuración de la base de datos
const dbConfig = {
    user: 'manu',           
    password: '12345',    
    server: 'localhost',         
    database: 'Barberia-app',        
    options: {
        encrypt: false,           
        trustServerCertificate: true 
    }
};


async function conectarBaseDatos() {
    try {
        const pool = await sql.connect(dbConfig);
        console.log('Conexión exitosa a la base de datos');
        return pool;
    } catch (err) {
        console.error('Error conectando a la base de datos:', err);
        throw err; 
    }
}

// Exportar la función de conexión y la librería sql
module.exports = {
    conectarBaseDatos,
    sql
};
