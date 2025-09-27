const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const { MongoClient } = require("mongodb");

const app = express();
const PORT = process.env.PORT || 4000;
const MONGO_URL = "mongodb://localhost:27017";
const DB_NAME = "menus_nearby";

app.use(cors());
app.use(bodyParser.json());

let db;

// Connect to MongoDB
MongoClient.connect(MONGO_URL, { useUnifiedTopology: true })
  .then((client) => {
    db = client.db(DB_NAME);
    console.log("Connected to MongoDB");
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch((err) => {
    console.error("Failed to connect to MongoDB", err);
    process.exit(1);
  });

app.post("/api/signup", async (req, res) => {
  console.log("Received signup:", req.body);
  const { email } = req.body;
  if (!email) return res.status(400).json({ error: "Email required" });

  try {
    const exists = await db.collection("signups").findOne({ email });
    if (exists)
      return res.status(409).json({ error: "Email already registered" });

    // Correct time handling
    const now = new Date();
    const lebanonTime = now.toLocaleString("en-US", {
      timeZone: "Asia/Beirut",
    });
    console.log(lebanonTime);

    await db.collection("signups").insertOne({ email, createdAt: lebanonTime });
    res.json({ ok: true });
  } catch (err) {
    console.error("DB error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

app.get("/api/health", (req, res) => {
  res.json({ status: "ok" });
});
