const mongoose = require('mongoose');
const User = require('./models/user');
const Tweet = require('./models/tweet');

// Connect to MongoDB using Mongoose
mongoose.connect('mongodb://localhost:27017/TwitterCloneV2', { useNewUrlParser: true, useUnifiedTopology: true });

async function seedDatabase() {
    // Create some users
    const alice = new User({
        name: 'Alice',
        username: 'alice',
        profileImage: 'alice.jpeg',
        email: 'alice@example.com', // Add this line
        password: 'password123' // Add this line
    });
    await alice.save();
    
    const bob = new User({
        name: 'Bob',
        username: 'bob',
        profileImage: 'bob.jpeg',
        email: 'bob@example.com', // Add this line
        password: 'password123' // Add this line
    });
    await bob.save();
    
    
    // Create some tweets
    const tweet1 = new Tweet({ text: 'Hello, world!', timestamp: '2023-06-10T10:00:00Z', user: alice });
    await tweet1.save();
    
    const tweet2 = new Tweet({ text: 'Bonjour, monde!', timestamp: '2023-06-10T11:00:00Z', user: bob });
    await tweet2.save();
    
    console.log('Database seeded!');
}

seedDatabase().then(() => {
    process.exit();
});