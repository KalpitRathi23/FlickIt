const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');
const connectDB = require('./utils/db');
const cors = require('cors');

dotenv.config();
connectDB();

const app = express();
app.use(bodyParser.json());
app.use(cors());

app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/drills', require('./routes/drillRoutes'));
app.use('/api/leaderboard', require('./routes/leaderboardRoutes'));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
