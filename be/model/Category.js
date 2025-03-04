const mongoose = require("mongoose");

const CategorySchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
            unique: true,
            trim: true
        }, // Tên danh mục (VD: SUV, Sedan, Toyota)
        type: {
            type: String,
            enum: ["loai_xe", "hang", "loai_nhienlieu", "loai_dongco", "mausac"],
            required: true
        }, // Loại danh mục
        description: {
            type: String
        }
    },
    { timestamps: true }
);

module.exports = mongoose.model("Category", CategorySchema);
