const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const searchRoute = require('./routes/search');
const User = require('./models/user');
const homeRoute = require('./routes/home');
const userTweetsRoute = require('./routes/userTweets'); // Update the route import

const { router: authRoute } = require('./routes/auth');
const app = express();

mongoose.connect('mongodb://localhost:27017/TwitterCloneV2', { useNewUrlParser: true, useUnifiedTopology: true });

app.use(bodyParser.json());
app.use('/search', searchRoute);
app.use('/home', homeRoute);
app.use('/home/user-tweets', userTweetsRoute); // Mount the userTweetsRoute at the correct endpoint
app.use('/auth', authRoute);



app.get('/users', async (req, res) => {
  try {
    const users = await User.find({}, 'id');
    const uuids = users.map(user => user.id);
    res.json({ uuids });
  } catch (error) {
    res.status(500).json({ message: 'Something went wrong' });
  }
});



app.listen(3000, () => {
  console.log('Server listening on port 3000');
});
