const Drill = require('../models/Drill');
const UserDrillData = require('../models/UserDrillData');
const User = require('../models/User');

exports.generateDrills = async () => {
    const drills = [
      { name: 'Toe Taps', totalCount: 40, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgkIIyaOnW3MbqsNLayuqGs2vA8PgqKhHmpA&s' },
      { name: 'Dribble Cones', totalCount: 30, imageUrl: 'https://www.sportsessionplanner.com/uploads/images/session_transitions/7090598.jpg' },
      { name: 'Shooting Practice', totalCount: 60, imageUrl: 'https://www.pendlesportswear.co.uk/blog/wp-content/uploads/Speed-4.jpg' },
      { name: 'Passing Accuracy', totalCount: 20, imageUrl: 'https://www.sportsessionplanner.com/uploads/images/session_transitions/178726.jpg' },
      { name: 'Goalkeeping Reflexes', totalCount: 25, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5aYq-uzE2AJ3KWyYR-GDkYF_eNiFnmFgA2A&s' },
      { name: 'Sprint Drills', totalCount: 15, imageUrl: 'https://www.sportsessionplanner.com/uploads/images/session_transitions/1246895.jpg' },
      { name: 'Header Practice', totalCount: 45, imageUrl: 'https://editorial.uefa.com/resources/025e-0fb60fba795a-1979552bb83b-1000/the_guidelines_aim_to_limit_the_header_burden_in_youth_football.jpeg' },
      { name: 'Crossing Accuracy', totalCount: 55, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9PdVCvex8EPRyBu_Lm6WvkUQYZq85AjN8jg&s' },
      { name: 'Defensive Drills', totalCount: 50, imageUrl: 'https://soccerblade.com/wp-content/uploads/2022/06/Soccer-defender-holding-off-an-attacker.webp' },      
      { name: 'Penalty Shootouts', totalCount: 25, imageUrl: 'https://www.sportsessionplanner.com/uploads/images/session_transitions/573968.jpg' },
    ];

    try {
      await Drill.insertMany(drills);
    } catch (error) {
      console.error('Error during drill generation:', error.message);
    }
};

exports.getDrills = async (req, res) => {
  try {
    const drills = await Drill.find().select('_id name totalCount imageUrl');
    res.status(200).json(drills);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


exports.submitDrillCount = async (req, res) => {
  const { userId, drillId, completedCount } = req.body;

  try {
    const drill = await Drill.findById(drillId);
    if (!drill) return res.status(404).json({ error: 'Drill not found' });

    if (completedCount > drill.totalCount) {
      return res.status(400).json({ error: 'Completed count exceeds total count' });
    }

    const existingUserDrill = await UserDrillData.findOne({ userId, drillId });

    if (existingUserDrill) {
      const countDifference = completedCount - existingUserDrill.completedCount;
      existingUserDrill.completedCount = completedCount;
      await existingUserDrill.save();

      const user = await User.findByIdAndUpdate(userId, { $inc: { totalCount: countDifference } });
      if (!user) return res.status(404).json({ error: 'User not found' });

      return res.status(200).json({ message: 'Drill count updated successfully' });
    } else {
      const userDrillData = new UserDrillData({ userId, drillId, completedCount });
      await userDrillData.save();

      const user = await User.findByIdAndUpdate(userId, { $inc: { totalCount: completedCount } });
      if (!user) return res.status(404).json({ error: 'User not found' });

      return res.status(201).json({ message: 'Drill count submitted successfully' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


exports.getUserDashboard = async (req, res) => {
  const { userId } = req.params;

  try {
    const userDrills = await UserDrillData.find({ userId })
      .populate('drillId', 'name totalCount')
      .exec();

    const formattedData = userDrills.map((entry) => ({
      drillName: entry.drillId.name,
      totalCount: entry.drillId.totalCount,
      completedCount: entry.completedCount,
    }));

    res.status(200).json(formattedData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

