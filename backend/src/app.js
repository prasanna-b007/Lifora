const express = require("express");
const cors = require("cors");

const emergencyRoutes = require("./routes/emergency.routes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api", emergencyRoutes);

module.exports = app;