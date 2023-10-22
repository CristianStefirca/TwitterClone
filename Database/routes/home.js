const express = require('express');
const router = express.Router();
const User = require('../models/user');
const Tweet = require('../models/tweet');

// Fetch all tweets
router.get('/', async (req, res) => {
  try {
    const users = await User.find();
    const tweets = await Tweet.find().populate('user');
    res.json({ users, tweets });
  } catch (error) {
    res.status(500).json({ message: 'Something went wrong' });
  }
});

// Fetch user-specific tweets
router.get('/user-tweets/:userUUID', async (req, res) => {
  const userUUID = req.params.userUUID;

  try {
    const tweets = await Tweet.find({ 'user.id': userUUID }).populate('user');
    res.json({ tweets });
  } catch (error) {
    res.status(500).json({ message: 'Something went wrong' });
  }
});

module.exports = router;
