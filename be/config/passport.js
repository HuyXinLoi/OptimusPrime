const passport = require("passport");
const GoogleStrategy = require("passport-google-oauth20").Strategy;
const User = require("../model/User");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
passport.use(
    new GoogleStrategy(
        {
            clientID: process.env.GOOGLE_CLIENT_ID,
            clientSecret: process.env.GOOGLE_CLIENT_SECRET,
            callbackURL: process.env.GOOGLE_CALLBACK_URL,

            scope: ["profile", "email"],
        },
        async (accessToken, refreshToken, profile, done) => {
            try {
                const email = profile.emails[0].value;
                const existingUser = await User.findOne({ email });

                if (existingUser) {
                    const token = jwt.sign(
                        { user: { id: existingUser._id, role: existingUser.role } },
                        process.env.JWT_SECRET,
                        { expiresIn: "40h" }
                    );
                    return done(null, { user: existingUser, token });
                }

                // Định nghĩa các link avatar mặc định theo giới tính
                const defaultAvatars = {
                    male: "https://res.cloudinary.com/djg7zqlus/image/upload/v1739692232/default_male_zxfurr.png", // Link avatar cho nam
                    female: "https://res.cloudinary.com/djg7zqlus/image/upload/v1739692232/default_female_gnxu7x.png", // Link avatar cho nữ
                    other: "https://res.cloudinary.com/djg7zqlus/image/upload/v1739709646/default_uxf9nl.png", // Link avatar cho other
                };

                // Lấy thông tin giới tính từ profile (nếu có), nếu không thì mặc định là "other"
                const gender = profile.gender || "other";
                // Gán avatar theo giới tính mặc định
                const avatar = defaultAvatars[gender];

                const newUser = new User({
                    name: profile.displayName,
                    email: email,
                    password: crypto.randomBytes(20).toString("hex"), // Tạo password ngẫu nhiên
                    gender: gender,
                    avatar: avatar,
                });

                await newUser.save();

                const token = jwt.sign({ user: { id: newUser._id, role: newUser.role } }, process.env.JWT_SECRET, {
                    expiresIn: "40h",
                });

                done(null, { user: newUser, token });
            } catch (error) {
                done(error, false);
            }
        }
    )
);

// Không cần serialize nếu không dùng session
passport.serializeUser((user, done) => done(null, user));
passport.deserializeUser((user, done) => done(null, user));

module.exports = passport;
