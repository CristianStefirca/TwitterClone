const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');
const uniqid = require('uniqid');
const crypto = require('crypto');

// Generate a random secret key
const secretKey = crypto.randomBytes(32).toString('hex');

router.post('/register', async (req, res) => {
  try {
    console.log('Register request received');
    console.log(req.body);
    const { name, username, profileImage, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'User with given email already exists' });
    }

    const id = uniqid();
    const hashedPassword = await bcrypt.hash(password, 12);

    const user = new User({ id, name, username, profileImage, email, password: hashedPassword });
    await user.save();

    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ message: 'Something went wrong' });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }
    
    const token = generateToken(user.id);

    res.json({ token });
  } catch (error) {
    console.log(error)
    res.status(500).json({ message: 'Something went wrong' });
  }
});

function generateToken(userId) {
  const token = jwt.sign(
    { id: userId },
    secretKey,
    { expiresIn: '1h' }
  );
  return token;
}

module.exports = {
  router: router
};
