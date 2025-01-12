const User = require('../models/User');

exports.getLeaderboard = async (req, res) => {
  try {
    const leaderboard = await User.find()
      .sort({ totalCount: -1 })
      .select('username totalCount');
    res.status(200).json(leaderboard);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
