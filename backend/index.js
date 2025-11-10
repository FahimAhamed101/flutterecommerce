const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, './.env') });




// IMPORT FROM PACKAGES
const cors = require('cors');
const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");

const productRouter = require("./routes/product");

const sellerRouter = require("./routes/seller");


// INIT
const PORT = process.env.PORT || 4000;
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

app.use(cors({
  origin: [
    'http://localhost:4000',
    'http://10.0.2.2:4000',
    'http://localhost', 
    'http://10.0.2.2'
  ],
  credentials: true
}));

app.use(express.json());
app.use(authRouter);
app.use(sellerRouter);

app.use(productRouter);


// Connection
mongoose.connect(DB).then(() => {
    console.log("Connection Mongodb Successful");
}).catch((e) => {
    console.log("Failed to connect Mongodb:", e.message);
});

app.get('/', (req, res) => {
    res.send('Hello from Express!');
});

app.listen(4000, '0.0.0.0', () => { // Listen on all interfaces
  console.log('Server running on http://localhost:4000');
  console.log('Server also accessible on http://10.0.2.2:4000 (for Android emulator)');
});