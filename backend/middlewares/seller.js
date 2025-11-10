const jwt = require('jsonwebtoken');
const User = require('../models/user');
const admin = async (req, res, next) => {
    try {
        // Get token from Authorization header (Bearer format)
        const authHeader = req.header("Authorization");
        
        if(!authHeader || !authHeader.startsWith("Bearer ")) {
            return res.status(401).json({msg: "No auth token, access denied"});
        }
        
        const token = authHeader.substring(7); // Remove "Bearer " prefix
        
        // Rest of the code remains the same...
        const verified = jwt.verify(token, "passwordKey");
        if(!verified) {
            return res.status(401).json({msg: "Token verification failed, authorization denied"});
        }
        
        const user = await User.findById(verified.id);
        if(!user) {
            return res.status(401).json({msg: "User not found"});
        }
        
        if(user.type !== "seller") {
            return res.status(403).json({msg: "Access denied. Admin privileges required."});
        }
        
        req.user = verified.id;
        req.token = token;
        req.userType = user.type;
        
        next();
    } catch (e) {
        if (e.name === 'JsonWebTokenError') {
            return res.status(401).json({msg: "Invalid token"});
        }
        if (e.name === 'TokenExpiredError') {
            return res.status(401).json({msg: "Token expired"});
        }
        res.status(500).json({ error: e.message});
    }
}
module.exports = admin;