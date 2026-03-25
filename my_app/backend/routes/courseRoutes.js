const express = require('express');
const router = express.Router();
const { getCourses, getCourseById, enrollCourse, getMyCourses, updateProgress } = require('../controllers/courseController');
const { protect } = require('../middleware/auth');

// Public
router.get('/', getCourses);
router.get('/:id', getCourseById);

// Private
router.get('/me/my-courses', protect, getMyCourses);
router.post('/:id/enroll', protect, enrollCourse);
router.put('/:id/progress', protect, updateProgress);

module.exports = router;
