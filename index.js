import express from "express";

const app = express();
const PORT = process.env.PORT ?? 8080;

app.get("/", (req, res) => {
  return res.json({ message: "hello from the server" });
});

app.listen(PORT, () => {
  console.log(`server is running on port ${PORT}`);
});
