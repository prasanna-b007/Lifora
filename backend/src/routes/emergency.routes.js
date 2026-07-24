const express = require("express");

const router = express.Router();

const emergencyController = require("../controllers/emergency.controller");

router.get("/test", (req, res) => {
    res.json({
        message: "Backend is running",
    });
});

router.post("/send", emergencyController.sendTestMessage);

module.exports = router;