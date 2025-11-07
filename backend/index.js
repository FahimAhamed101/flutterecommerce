const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, './.env') });




// IMPORT FROM PACKAGES
const cors = require('cors');
const express = require("express");
const mongoose = require("mongoose");

// INIT
const PORT = process.env.PORT || 3000;
const app = express();

// Try multiple possible environment variable names
const DB = process.env.MONGODB_URL || process.env.MONGODB_URI || process.env.MONGO_URI;

// Check if DB connection string exists
if (!DB) {
    console.error('ERROR: MongoDB connection string not found!');
    console.error('Please check your .env file has one of: MONGODB_URL, MONGODB_URI, or MONGO_URI');
    process.exit(1);
}

console.log('MongoDB URL:', DB.substring(0, 20) + '...'); // Show partial URL for security

// middleware
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'x-auth-token'],
    credentials: true
}));

app.use(express.json());

// Connection
mongoose.connect(DB).then(() => {
    console.log("Connection Mongodb Successful");
}).catch((e) => {
    console.log("Failed to connect Mongodb:", e.message);
});

app.get('/', (req, res) => {
    res.send('Hello from Express!');
});

app.listen(PORT, () => { 
    console.log(`connected at port ${PORT}`);
});
