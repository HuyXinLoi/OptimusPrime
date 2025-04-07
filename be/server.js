require("dotenv").config();
const express = require("express");
const cors = require("cors");
// const dotenv = require("dotenv");
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const categoryRoutes = require("./routes/categoryRoutes");
const productRoutes = require("./routes/productRoutes");
const cartRoutes = require("./routes/cartRoutes");
const passport = require("./config/passport");

const app = express();
app.use(express.json());
app.use(cors());

// dotenv.config();
app.use(passport.initialize());
// console.log(process.env.PORT);

const PORT = process.env.PORT || 9000;

connectDB();

app.get("/", (req, res) => {
    res.send("Welcome to the server");
});

//API routes
app.use("/api/users", userRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/products", productRoutes);
app.use("/api/cart", cartRoutes);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
