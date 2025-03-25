// routes/cartRoutes.js
const express = require("express");
const Cart = require("../model/Cart");
const Product = require("../model/Product");
const Order = require("../model/Order");
const { protect } = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/add",protect, async (req, res) => {
    try {
        const { productId, quantity } = req.body;
        const userId = req.user.id;

        const product = await Product.findById(productId);
        if (!product) return res.status(404).json({ message: "Product not found" });

        let cart = await Cart.findOne({ user: userId });
        if (!cart) {
            cart = new Cart({ user: userId, items: [], totalPrice: 0 });
        }

        const existingItem = cart.items.find(item => item.product.toString() === productId);
        if (existingItem) {
            existingItem.quantity += quantity;
            existingItem.price = existingItem.quantity * product.price;
        } else {
            cart.items.push({ product: productId, quantity, price: quantity * product.price });
        }

        cart.totalPrice = cart.items.reduce((sum, item) => sum + item.price, 0);
        await cart.save();

        res.status(200).json(cart);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post("/remove",protect, async (req, res) => {
    try {
        const { productId } = req.body;
        const userId = req.user.id;

        let cart = await Cart.findOne({ user: userId });
        if (!cart) return res.status(404).json({ message: "Cart not found" });

        cart.items = cart.items.filter(item => item.product.toString() !== productId);
        cart.totalPrice = cart.items.reduce((sum, item) => sum + item.price, 0);
        await cart.save();

        res.status(200).json(cart);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post("/checkout",protect, async (req, res) => {
    try {
        const userId = req.user.id;
        const { address, phone, paymentMethod } = req.body;

        let cart = await Cart.findOne({ user: userId }).populate("items.product");
        if (!cart || cart.items.length === 0) return res.status(400).json({ message: "Cart is empty" });

        const order = new Order({
            user: userId,
            items: cart.items,
            totalPrice: cart.totalPrice,
            address,
            phone,
            paymentMethod,
            status: "Pending",
        });

        await order.save();
        await Cart.findOneAndDelete({ user: userId });

        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


// @routes GET api/cart
// @desc Get all carts
// @access Private (Admin only)
router.get("/", protect, async (req, res) => {
    try {
        // Kiểm tra quyền Admin
        if (req.user.role !== "admin") {
            return res.status(403).json({ message: "Access denied. Admins only." });
        }

        const carts = await Cart.find().populate("user", "name email").populate("items.product", "name price");
        res.status(200).json(carts);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


module.exports = router;
