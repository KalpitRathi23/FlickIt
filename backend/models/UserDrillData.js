const mongoose = require('mongoose');

const UserDrillDataSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  drillId: { type: mongoose.Schema.Types.ObjectId, ref: 'Drill', required: true },
  completedCount: { type: Number, required: true },
});

module.exports = mongoose.model('UserDrillData', UserDrillDataSchema);
