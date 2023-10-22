const express = require('express');
const router = express.Router();
const User = require('../models/user');

// Search for users by username
router.get('/:name', async (req, res) => {
    const name = req.params.name;
    console.log(`Search query: ${name}`); // Log the search query
  
    try {
      // Find users whose name contains the search query
      const users = await User.find({ name: new RegExp(name, 'i') });
      console.log(`Search results: ${JSON.stringify(users)}`); // Log the search results
      res.json({ users });
    } catch (error) {
      res.status(500).json({ message: 'Something went wrong' });
    }
  });
  
  

// Follow a user
router.post('/follow/:currentUserId/:userIdToFollow', async (req, res) => {
  const currentUserId = req.params.currentUserId;
  const userIdToFollow = req.params.userIdToFollow;

  try {
      // Find the current user and the user to follow
      const currentUser = await User.findOne({ _id: currentUserId });
      const userToFollow = await User.findOne({ _id: userIdToFollow });

      // Check if the users exist
      if (!currentUser || !userToFollow) {
          return res.status(404).json({ message: 'User not found' });
      }

      // Add the user to follow to the current user's following array
      currentUser.following.push(userToFollow._id);
      await currentUser.save();

      res.json({ message: 'User followed successfully' });
  } catch (error) {
      res.status(500).json({ message: 'Something went wrong' });
  }
});


// Unfollow a user
router.post('/unfollow/:currentUserId/:userIdToUnfollow', async (req, res) => {
  const currentUserId = req.params.currentUserId;
  const userIdToUnfollow = req.params.userIdToUnfollow;

  try {
      // Find the current user
      const currentUser = await User.findOne({ _id: currentUserId });

      // Check if the current user exists
      if (!currentUser) {
          return res.status(404).json({ message: 'User not found' });
      }

      // Remove the user to unfollow from the current user's following array
      currentUser.following = currentUser.following.filter(id => id.toString() !== userIdToUnfollow);
      await currentUser.save();

      res.json({ message: 'User unfollowed successfully' });
  } catch (error) {
      res.status(500).json({ message: 'Something went wrong' });
  }
});




module.exports = router;
