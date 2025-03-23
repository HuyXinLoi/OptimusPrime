const express = require("express");
const Category = require("../model/Category");
const admin = require("../middleware/adminMiddleware");
const { protect } = require("../middleware/authMiddleware");

const router = express.Router();

// @route   GET /api/categories
// @desc    Lấy tất cả categories
// @access  Public
router.get("/", async (req, res) => {
  try {
    const categories = await Category.find();
    res.status(200).json(categories);
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Lỗi server" });
  }
});

// @route   GET /api/categories/:id
// @desc    Lấy category theo ID
// @access  Public
router.get("/:id", async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) return res.status(404).json({ message: "Không tìm thấy category" });

    res.status(200).json(category);
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Lỗi server" });
  }
});

// @route   POST /api/categories
// @desc    Thêm mới category
// @access  Public
router.post("/add-category", protect, admin, async (req, res) => {
  try {
    const { name, type, description } = req.body;

    if (!name || !type) return res.status(400).json({ message: "Tên và loại category là bắt buộc" });

    let category = await Category.findOne({ name, type });
    if (category) return res.status(400).json({ message: "Category đã tồn tại" });

    category = new Category({ name, type, description });
    await category.save();

    res.status(201).json({ message: "Category được tạo thành công", category });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Lỗi server" });
  }
});

// @route   PUT /api/categories/update/:id
// @desc    Cập nhật category
// @access  Public
router.put("/update/:id",protect, admin, async (req, res) => {
  try {
    const { name, type, description } = req.body;

    const category = await Category.findByIdAndUpdate(
      req.params.id,
      { name, type, description },
      { new: true }
    );

    if (!category) return res.status(404).json({ message: "Không tìm thấy category" });

    res.status(200).json({ message: "Category cập nhật thành công", category });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Lỗi server" });
  }
});

// @route   DELETE /api/categories/delete/:id
// @desc    Xóa category
// @access  Public
router.delete("/delete/:id",protect, admin, async (req, res) => {
  try {
    const category = await Category.findByIdAndDelete(req.params.id);
    if (!category) return res.status(404).json({ message: "Không tìm thấy category" });

    res.status(200).json({ message: "Category đã bị xóa thành công" });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Lỗi server" });
  }
});
// @route   POST /api/categories/filter
// @desc    Lọc categories theo type (Enum) bằng JSON body
// @access  Public
router.post("/filter", async (req, res) => {
  try {
    const { type } = req.body;

    // Danh sách giá trị hợp lệ
    const validTypes = ["loai_xe", "hang", "loai_nhienlieu", "loai_dongco", "mausac"];
    
    // Kiểm tra nếu type không hợp lệ
    if (!validTypes.includes(type)) {
      return res.status(400).json({ message: "Type không hợp lệ" });
    }

    // Tìm kiếm category theo type
    const categories = await Category.find({ type });

    res.status(200).json(categories);
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Lỗi server" });
  }
});


module.exports = router;
