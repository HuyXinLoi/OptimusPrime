//Middleware to check if the user is admin
const admin = (req, res, next) => {
    if (req.user.role !== "admin") {
        return res.status(401).json({ message: "Bạn không có quyền truy cập" });
    }
    next();
};

module.exports = admin;
