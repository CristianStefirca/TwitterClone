const mongoose = require('mongoose');
const User = require('./user');

// Define Mongoose schema for tweets
const tweetSchema = new mongoose.Schema({
    text: String,
    timestamp: String,
    user: User.schema
});

// Create and export Mongoose model for tweets
module.exports = mongoose.model('Tweet', tweetSchema);