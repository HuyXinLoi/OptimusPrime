//user routes
const express = require("express");
const User = require("../model/User");
const jwt = require("jsonwebtoken");
const router = express.Router();
const { protect } = require("../middleware/authMiddleware");
const nodeMailer = require("nodemailer");
const crypto = require("crypto");
const passport = require("passport");
const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({ storage });
const cloudinary = require("../config/cloudinaryConfig");

// @routes POST api/users/register
// @desc Register user
// @access Public
router.post("/register", async (req, res) => {
    const { name, email, confirmPassword, password, gender } = req.body;

    try {
        //check user
        let user = await User.findOne({ email });
        if (user) {
            return res.status(400).json({ msg: "User already exists" });
        }

        if (!confirmPassword || password !== confirmPassword) {
            return res.status(400).json({ msg: "Password and confirm password do not match" });
        }

        // Xử lý upload avatar nếu có file gửi lên
        let avatar = "";
        if (gender == "male") {
            avatar = "https://res.cloudinary.com/djg7zqlus/image/upload/v1739692232/default_male_zxfurr.png";
        } else if (gender == "female") {
            avatar = "https://res.cloudinary.com/djg7zqlus/image/upload/v1739692232/default_female_gnxu7x.png";
        } else {
            avatar = "https://res.cloudinary.com/djg7zqlus/image/upload/v1739709646/default_uxf9nl.png";
        }
        //create user
        user = new User({
            name,
            email,
            password,
            gender,
            avatar,
        });
        await user.save();

        //create jwt payload
        const payload = {
            user: {
                id: user._id,
                role: user.role,
            },
        };

        //sign and return the token along with user data
        jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "40h" }, (err, token) => {
            if (err) throw err;
            res.status(201).json({
                user: {
                    _id: user._id,
                    name: user.name,
                    email: user.email,
                    gender: user.gender,
                    avatar: user.avatar,
                    role: user.role,
                },
                token,
                message: "User created successfully",
            });
        });
    } catch (error) {
        console.error(error.message);
        res.status(500).send("Error in saving");
    }
});

// @routes POST api/users/login
// @desc Authenticate user
// @access Public
router.post("/login", async (req, res) => {
    const { email, password } = req.body;

    try {
        //check user
        let user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ msg: "Invalid credentials" });
        }
        //login user with jwt token
        const isMatch = await user.matchPasswords(password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Invalid credentials" });
        }
        //get token
        const payload = {
            user: {
                id: user._id,
                role: user.role,
            },
        };
        jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "40h" }, (err, token) => {
            if (err) throw err;
            res.json({
                user: {
                    _id: user._id,
                    name: user.name,
                    email: user.email,
                    role: user.role,
                },
                token,
                message: "User logged in successfully",
            });
        });
    } catch (error) {
        console.error(error.message);
        res.status(500).send("Error in login");
    }
});

// @routes POST api/users/forgotpassword
// @desc send email to reset password
// @access Public
router.post("/forgotpassword", async (req, res) => {
    const { email } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({ message: "User not found with this email" });
        }

        //get reset token
        const resetToken = user.getResetPasswordToken();
        await user.save({ validateBeforeSave: false });

        //create reset url
        const resetUrl = `${req.protocol}://${req.get("host")}/api/users/resetpassword/${resetToken}`;

        //send email
        const transporter = nodeMailer.createTransport({
            host: process.env.EMAIL_HOST,
            port: process.env.EMAIL_PORT,
            secure: false,
            auth: {
                user: process.env.EMAIL_USERNAME,
                pass: process.env.EMAIL_PASSWORD,
            },
            tls: {
                rejectUnauthorized: false,
            },
        });

        //Nội dung email
        const mailOptions = {
            from: '"Fred Foo 👻" <foo@example.com>', // sender address
            to: user.email, // list of receivers
            subject: "Password Reset Request", // Subject line
            text: `You are receiving this email because you (or someone else) has requested the reset of a password. Please click on the following link, or paste this into your browser to complete the process:\n\n${resetUrl}\n\nIf you did not request this, please ignore this email and your password will remain unchanged.\n`, // plain text body
            html: `<p>You are receiving this email because you (or someone else) has requested the reset of a password. Please click on the following link, or paste this into your browser to complete the process:</p><p><a href="${resetUrl}">${resetUrl}</a></p><p>If you did not request this, please ignore this email and your password will remain unchanged.</p>`,
        };

        await transporter.sendMail(mailOptions);

        res.status(200).json({
            message: `Reset password email sent to ${user.email}`,
        });
    } catch (error) {
        console.error(error.message);
        user.resetPasswordToken = undefined;
        user.resetPasswordExpire = undefined;
        await user.save({ validateBeforeSave: false });
        res.status(500).send("Error in reset password");
    }
});

// @routes PUT api/users/resetpassword/:token
// @desc Reset password
// @access Public
router.put("/resetpassword/:token", async (req, res) => {
    const { password, confirmPassword } = req.body;

    // Kiểm tra xác nhận mật khẩu
    if (!confirmPassword || password !== confirmPassword) {
        return res.status(400).json({ message: "Password and confirm password do not match" });
    }
    // Lấy token từ params
    const resetPasswordToken = crypto.createHash("sha256").update(req.params.token).digest("hex");

    try {
        // Tìm user theo resetPasswordToken và kiểm tra thời gian hết hạn
        const user = await User.findOne({
            resetPasswordToken,
            resetPasswordExpire: { $gt: Date.now() }, // Token còn hạn
        });

        if (!user) {
            return res.status(400).json({ message: "Invalid or expired token" });
        }

        // Đặt mật khẩu mới
        user.password = password;

        // Xóa reset token
        user.resetPasswordToken = undefined;
        user.resetPasswordExpire = undefined;

        await user.save();

        res.status(200).json({ message: "Password reset successfully" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
});

// ====== GOOGLE LOGIN ======
/*
  1) Khi người dùng truy cập /api/users/google,
     passport sẽ chuyển hướng sang trang đăng nhập của Google
     với scope là "profile" và "email"
*/
router.get("/google", passport.authenticate("google", { scope: ["profile", "email"] }));

/*
  2) Google sẽ callback về route này: /api/users/google/callback
     Ở đây passport.authenticate sẽ gọi đến strategy Google
     => Lấy thông tin user => done => successRedirect hoặc failRedirect
*/
router.get(
    "/google/callback",
    passport.authenticate("google", {
        failureRedirect: "/login", // Nếu fail thì redirect
        session: false, // Tắt session vì ta dùng JWT
    }),
    (req, res) => {
        // Thành công, passport sẽ gắn user + token vào req.user (theo code ở passport.js)
        const { user, token } = req.user;
        // Từ đây, bạn có thể trả về JSON, hoặc redirect về 1 URL trên frontend.
        // Thí dụ: trả về token JSON:
        return res.json({
            success: true,
            message: "Login Google thành công!",
            user: {
                _id: user._id,
                name: user.name,
                email: user.email,
                role: user.role,
                gender: user.gender,
                avatar: user.avatar,
            },
            token: token,
        });
    }
);

//PROFILE
// @routes GET api/users/profile
// @desc Get user profile
// @access Private
router.get("/profile", protect, async (req, res) => {
    try {
        // const user = await User.findById(req.user.id).select("-password");
        res.json(req.user);
    } catch (error) {
        console.error(error.message);
        res.status(500).send("Error in getting profile");
    }
});

// @routes PUT api/user/profile
// @desc Update personal profile information
// @access Private
router.put("/profile", protect, upload.single("avatar"), async (req, res) => {
    try {
        const { name, gender, birthday, address, phone, avatar } = req.body;
        const user = await User.findById(req.user._id);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        const defaultAvatars = {
            male: "https://res.cloudinary.com/djg7zqlus/image/upload/v1739692232/default_male_zxfurr.png",
            female: "https://res.cloudinary.com/djg7zqlus/image/upload/v1739692232/default_female_gnxu7x.png",
            other: "https://res.cloudinary.com/djg7zqlus/image/upload/v1739709646/default_uxf9nl.png",
        };

        if (name) user.name = name;
        if (birthday) user.birthday = birthday;
        if (address) user.address = address;
        if (phone) user.phone = phone;

        // Xử lý avatar: nếu có file mới được upload
        if (req.file) {
            try {
                const uploadResult = await new Promise((resolve, reject) => {
                    const stream = cloudinary.uploader.upload_stream({ folder: "users_avatars" }, (error, result) => {
                        if (error) reject(error);
                        else resolve(result);
                    });
                    stream.end(req.file.buffer);
                });
                user.avatar = uploadResult.secure_url;
            } catch (uploadError) {
                console.error("Error uploading to Cloudinary:", uploadError);
                return res.status(500).json({ message: "Error uploading image" });
            }
        } else if (gender && gender !== user.gender) {
            // Nếu gender thay đổi và không có file mới được upload,
            // nếu avatar hiện tại là mặc định thì cập nhật theo gender mới
            if (Object.values(defaultAvatars).includes(user.avatar)) {
                user.avatar = defaultAvatars[gender];
            }
            user.gender = gender;
        } else if (gender) {
            user.gender = gender;
        }

        await user.save();

        res.status(200).json({
            message: "Profile updated successfully",
            user: {
                _id: user._id,
                name: user.name,
                email: user.email,
                gender: user.gender,
                birthday: user.birthday,
                address: user.address,
                phone: user.phone,
                avatar: user.avatar,
                role: user.role,
            },
        });
    } catch (error) {
        console.error(error.message);
        res.status(500).send("Error in editing profile");
    }
});
module.exports = router;
