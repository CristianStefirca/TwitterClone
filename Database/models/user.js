const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  name: String,
  username: String,
  profileImage: String,
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  followers: [{ type: String }], // Array of UUIDs representing the followers
});

module.exports = mongoose.model('User', userSchema);
