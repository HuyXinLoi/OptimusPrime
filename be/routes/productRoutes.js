//Routes for Product

const express = require("express");
const router = express.Router();
const Product = require("../model/Product");
const Category = require("../model/Category");
const { protect } = require("../middleware/authMiddleware");
const admin = require("../middleware/adminMiddleware");
const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({ storage });
const cloudinary = require("../config/cloudinaryConfig");



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
            .populate("categories")
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


// API lọc sản phẩm dựa trên name của Category, có thể sắp xếp theo price
router.get("/filter", async (req, res) => {
    try {
        const { value, sort, minPrice, maxPrice } = req.query;
        let query = {};

        // Lọc theo danh mục (Category)
        if (value) {
            const category = await Category.findOne({ name: value });
            if (!category) {
                return res.status(404).json({ message: "No matching category found" });
            }
            query.categories = category._id;
        }

        // Lọc theo khoảng giá
        if (minPrice || maxPrice) {
            query.price = {};
            if (minPrice) query.price.$gte = parseFloat(minPrice);
            if (maxPrice) query.price.$lte = parseFloat(maxPrice);
        }

        // Xây dựng điều kiện sắp xếp
        let sortOrder = {};
        if (sort === "asc") sortOrder.price = 1;
        if (sort === "desc") sortOrder.price = -1;

        // Tìm sản phẩm theo điều kiện
        const productQuery = Product.find(query).populate("categories");
        if (sort) {
            productQuery.sort(sortOrder);
        }

        const products = await productQuery;

        res.json(products);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
});



// @route   GET /api/products/:id
// @desc    Lấy product theo ID
// @access  Public
router.get("/:id", async (req, res) => {
    try {
        const product = await Product.findById(req.params.id).populate("categories");
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
        const { name, price, description, quantity, categories, discount } = req.body;

        // Kiểm tra các trường bắt buộc
        if (!name || !price || !description || !quantity || !categories) {
            return res.status(400).json({ message: "Vui lòng điền đầy đủ thông tin" });
        }

        // Kiểm tra file hình ảnh
        if (!req.file) {
            return res.status(400).json({ message: "Vui lòng upload hình ảnh sản phẩm" });
        }

        // Kiểm tra sản phẩm có tồn tại không
        const productExists = await Product.findOne({ name });
        if (productExists) return res.status(400).json({ message: "Sản phẩm đã tồn tại" });

        // Upload hình ảnh lên Cloudinary
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

        const categoryArray = Array.isArray(categories) ? categories : [categories];
        const hasDuplicates = categoryArray.length !== new Set(categoryArray).size;
        if (hasDuplicates) {
            return res.status(400).json({ message: "Danh mục không được chứa giá trị trùng lặp" });
        }

        // (Tùy chọn) Kiểm tra các categories có tồn tại trong DB không
        const categoryExists = await Category.find({ _id: { $in: categoryArray } });
        if (categoryExists.length !== categoryArray.length) {
            return res.status(400).json({ message: "Một hoặc nhiều danh mục không tồn tại" });
        }
        const typeSet = new Set(categoryExists.map((cat) => cat.type));
        if (typeSet.size !== categoryExists.length) {
            return res.status(400).json({
                message: "Danh mục không được chứa các type trùng lặp",
            });
        }
        // Tạo sản phẩm mới với mảng categories đã loại bỏ trùng lặp
        const newProduct = new Product({
            name,
            price,
            description,
            quantity,
            image: imageUrl,
            categories: categoryArray,
            discount: discount || 0,
        });
        await newProduct.save();

        const populatedProduct = await Product.findById(newProduct._id).populate("categories");
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
        const product = await Product.findById(req.params.id).populate("categories");
        if (!product) return res.status(404).json({ message: "Không tìm thấy sản phẩm" });

        // Cập nhật các trường khác nếu chúng có trong request body
        if (updateData.name !== undefined) product.name = updateData.name;
        if (updateData.price !== undefined) product.price = updateData.price;
        if (updateData.description !== undefined) product.description = updateData.description;
        // if (updateData.category !== undefined) product.category = updateData.category;
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

        // Cập nhật danh mục
        // Xử lý cập nhật categories nếu có trong request body
        if (updateData.categories) {
            // Chuyển categories thành mảng (nếu không phải là mảng)
            const newCategories = Array.isArray(updateData.categories)
                ? updateData.categories
                : [updateData.categories];

            // Kiểm tra xem các categories có tồn tại trong DB không
            const categoryDocs = await Category.find({ _id: { $in: newCategories } });
            if (categoryDocs.length !== newCategories.length) {
                return res.status(400).json({ message: "Một hoặc nhiều danh mục không tồn tại" });
            }

            // Kiểm tra trùng lặp type trong newCategories
            const typeSet = new Set(categoryDocs.map((cat) => cat.type));
            if (typeSet.size !== categoryDocs.length) {
                return res.status(400).json({ message: "Danh mục không được chứa các type trùng lặp" });
            }

            // Lấy danh sách type của categories hiện tại trong product
            const currentCategoryTypes = product.categories.map((cat) => cat.type);

            // Tạo mảng categories mới
            let updatedCategories = [...product.categories]; // Sao chép categories hiện tại

            for (const newCategory of categoryDocs) {
                const newCategoryType = newCategory.type;
                const existingCategoryIndex = updatedCategories.findIndex((cat) => cat.type === newCategoryType);

                if (existingCategoryIndex !== -1) {
                    // Nếu type đã tồn tại, ghi đè category có type đó
                    updatedCategories[existingCategoryIndex] = newCategory._id;
                } else {
                    // Nếu type chưa tồn tại, thêm category mới vào mảng
                    updatedCategories.push(newCategory._id);
                }
            }

            // Cập nhật mảng categories của product
            product.categories = updatedCategories;
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


module.exports = router;
