//Routes for Product

const express = require("express");
const router = express.Router();
const Product = require("../model/Product");
const { protect } = require("../middleware/authMiddleware");
const admin = require("../middleware/adminMiddleware");
const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({ storage });
const cloudinary = require("../config/cloudinaryConfig");

// router.get("/", async (req, res) => {
//     try {
//         const products = await Product.find().populate("category");
//         if (!products) return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
//         res.status(200).json(products);
//     } catch (error) {
//         res.status(500).json({ message: "Lỗi server" });
//     }
// });
// @route GET /api/products
// @desc Lấy tất cả products
// @desc Tìm kiếm sản phẩm theo tên sản phẩm có phân trang
// @desc Phân trang sản phẩm
// @access Public
router.get("/", async (req, res) => {
    try {
        const { q = "", page = 1, limit = 10 } = req.query;
        const pageNum = parseInt(page);
        const limitNum = parseInt(limit);
        const skip = (pageNum - 1) * limitNum;

        const searchQuery = {
            name: { $regex: q, $options: "i" },
        };

        const totalProducts = await Product.countDocuments(searchQuery);
        const products = await Product.find(searchQuery)
            .populate("category")
            .skip(skip)
            .limit(limitNum)
            .sort({ createdAt: -1 });

        const totalPages = Math.ceil(totalProducts / limitNum);

        res.status(200).json({
            success: true,
            data: products,
            pagination: {
                currentPage: pageNum,
                totalPages: totalPages,
                totalItems: totalProducts,
                limit: limitNum,
                hasNext: pageNum < totalPages,
                hasPrevious: pageNum > 1,
            },
        });
    } catch (error) {
        console.error("Search error:", error);
        res.status(500).json({
            success: false,
            message: "Lỗi server",
            error: error.message,
        });
    }
});

// @route   GET /api/products/:id
// @desc    Lấy product theo ID
// @access  Public
router.get("/:id", async (req, res) => {
    try {
        const product = await Product.findById(req.params.id).populate("category");
        if (!product) return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ message: "Lỗi server" });
    }
});

// @route   POST /api/products
// @desc    Thêm sản phẩm mới
// @access  Private - chỉ admin
router.post("/add", protect, admin, upload.single("image"), async (req, res) => {
    try {
        const { name, price, description, quantity, category, discount } = req.body;
        // Chỉ kiểm tra các trường text từ req.body, không kiểm tra image
        if (!name || !price || !description || !quantity || !category || !discount) {
            return res.status(400).json({ message: "Vui lòng điền đầy đủ thông tin" });
        }

        // Kiểm tra xem có file hình ảnh được upload không
        if (!req.file) {
            return res.status(400).json({ message: "Vui lòng upload hình ảnh sản phẩm" });
        }

        // Kiểm tra sản phẩm có tồn tại trong database không
        const product = await Product.findOne({ name });
        if (product) return res.status(400).json({ message: "Sản phẩm đã tồn tại" });

        let imageUrl;
        try {
            const uploadResult = await new Promise((resolve, reject) => {
                const stream = cloudinary.uploader.upload_stream({ folder: "products" }, (error, result) => {
                    if (error) reject(error);
                    else resolve(result);
                });
                stream.end(req.file.buffer);
            });
            imageUrl = uploadResult.secure_url;
        } catch (uploadError) {
            console.error("Error uploading to Cloudinary:", uploadError);
            return res.status(500).json({ message: "Lỗi khi tải lên hình ảnh" });
        }

        const newProduct = new Product({
            name,
            price,
            description,
            quantity,
            image: imageUrl,
            category,
            discount: discount || 0,
        });
        await newProduct.save();
        const populatedProduct = await Product.findById(newProduct._id).populate("category");
        res.status(201).json({
            product: populatedProduct,
            message: "Thêm sản phẩm thành công",
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Lỗi server" });
    }
});

// @route   PUT /api/products/:id
// @desc    Cập nhật sản phẩm
// @access  Private - chỉ admin
router.put("/update/:id", protect, admin, upload.single("image"), async (req, res) => {
    try {
        const updateData = req.body;
        // Tìm sản phẩm theo id
        const product = await Product.findById(req.params.id).populate("category");
        if (!product) return res.status(404).json({ message: "Không tìm thấy sản phẩm" });

        // Cập nhật các trường khác nếu chúng có trong request body
        if (updateData.name !== undefined) product.name = updateData.name;
        if (updateData.price !== undefined) product.price = updateData.price;
        if (updateData.description !== undefined) product.description = updateData.description;
        if (updateData.category !== undefined) product.category = updateData.category;
        if (updateData.discount !== undefined) product.discount = updateData.discount;
        if (updateData.quantity !== undefined) product.quantity = updateData.quantity;

        // Xử lý cập nhật hình ảnh
        if (req.file) {
            try {
                const uploadResult = await new Promise((resolve, reject) => {
                    const stream = cloudinary.uploader.upload_stream({ folder: "products" }, (error, result) => {
                        if (error) reject(error);
                        else resolve(result);
                    });
                    stream.end(req.file.buffer);
                });
                product.image = uploadResult.secure_url;
            } catch (uploadError) {
                console.error("Error uploading to Cloudinary:", uploadError);
                return res.status(500).json({ message: "Error uploading image" });
            }
        } else {
            // Nếu không có file mới, giữ nguyên giá trị hiện tại của image (nếu có)
            if (!product.image) {
                return res.status(400).json({ message: "Hình ảnh là bắt buộc, vui lòng upload hình ảnh" });
            }
        }

        // Lưu sản phẩm đã cập nhật
        await product.save();

        res.status(200).json({
            product: product,
            message: "Sản phẩm đã được cập nhật",
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Lỗi server" });
    }
});

// @route   DELETE /api/products/:id
// @desc    Xóa sản phẩm
// @access  Private - chỉ admin
router.delete("/delete/:id", protect, admin, async (req, res) => {
    try {
        await Product.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: "Sản phẩm đã được xóa" });
    } catch (error) {
        res.status(500).json({ message: "Lỗi server" });
    }
});


router.get("/", async (req, res) => {
    try {
        const { type, value } = req.query;
        let filter = {};

        if (type && value) {
            const category = await Category.findOne({ type, name: value });
            if (category) {
                filter.category = category._id;
            } else {
                return res.json([]);
            }
        }

        const products = await Product.find(filter).populate("category");
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
});






module.exports = router;

