const express = require('express');
const router = express.Router();
const User = require('../models/user');
const Tweet = require('../models/tweet');

// Fetch all users' UUIDs
router.get('/uuids', async (req, res) => {
  try {
    const users = await User.find({}, { id: 1 });
    const uuids = users.map(user => user.id);
    res.json({ uuids });
  } catch (error) {
    res.status(500).json({ message: 'Something went wrong' });
  }
});

// Fetch user-specific tweets
router.get('/:userUUID', async (req, res) => {
  const userUUID = req.params.userUUID;

  try {
    // Fetch tweets for the specific userUUID
    const tweets = await Tweet.find({ 'user.id': userUUID }).populate('user');
    res.json({ tweets });
  } catch (error) {
    res.status(500).json({ message: 'Something went wrong' });
  }
});

// Create a new tweet for a user
router.post('/:userUUID', async (req, res) => {
  const userUUID = req.params.userUUID;
  const { text } = req.body;

  try {
    // Find the user based on the userUUID
    const user = await User.findOne({ id: userUUID });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Create a new tweet
    const tweet = new Tweet({
      text,
      timestamp: new Date().toISOString(),
      user: user._id
    });

    await tweet.save();

    res.status(201).json({ message: 'Tweet created successfully', tweet });
  } catch (error) {
    res.status(500).json({ message: 'Something went wrong' });
  }
});

module.exports = router;
