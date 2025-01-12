const mongoose = require('mongoose');

const DrillSchema = new mongoose.Schema({
  name: { type: String, required: true },
  totalCount: { type: Number, required: true },
  imageUrl: { type: String, required: true },
});

module.exports = mongoose.model('Drill', DrillSchema);
