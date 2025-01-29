const express = require('express');
const sql = require('mssql');
const app = express();
const port = 3000;

// Configuración de la conexión
const dbConfig = {
    user: 'tu_usuario',
    password: 'tu_contraseña',
    server: 'localhost',
    database: 'Barberia',
    options: {
        encrypt: false,
        trustServerCertificate: true,
    },
};

// Conexión a la base de datos
async function conectarBaseDatos() {
    try {
        await sql.connect(dbConfig);
        console.log('Conexión exitosa a la base de datos');
    } catch (err) {
        console.error('Error conectando a la base de datos:', err);
    }
}

app.get('/clientes', async (req, res) => {
    try {
        const result = await sql.query('SELECT * FROM Clientes');
        res.json(result.recordset);
    } catch (err) {
        console.error('Error al obtener los clientes:', err);
        res.status(500).send('Error al obtener los clientes');
    }
});

app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
    conectarBaseDatos();
});
