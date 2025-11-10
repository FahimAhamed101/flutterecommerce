const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
    try {
        let token;
        
        // Check for token in x-auth-token header
        if (req.header("x-auth-token")) {
            token = req.header("x-auth-token");
        } 
        // Check for token in Authorization header (Bearer format)
        else if (req.header("Authorization") && req.header("Authorization").startsWith("Bearer ")) {
            token = req.header("Authorization").substring(7);
        }
        
        if (!token) {
            return res.status(401).json({ msg: "No auth token, access denied" });
        }
        
        const verified = jwt.verify(token, "passwordKey");
        if (!verified) {
            return res.status(401).json({ msg: "Token verification failed, authorization denied" });
        }
        
        req.user = verified.id;
        req.token = token;
        next();
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

module.exports = auth;