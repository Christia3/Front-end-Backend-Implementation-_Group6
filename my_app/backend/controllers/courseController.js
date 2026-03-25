const pool = require('../config/db');

// @desc    Get all courses
// @route   GET /api/courses
// @access  Public
const getCourses = async (req, res, next) => {
  try {
    const { category, level, search, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    const values = [];
    let where = 'WHERE c.is_active = true';
    let idx = 1;

    if (category && category !== 'All') {
      where += ` AND c.category = $${idx++}`;
      values.push(category);
    }
    if (level) {
      where += ` AND c.level = $${idx++}`;
      values.push(level);
    }
    if (search) {
      where += ` AND (c.title ILIKE $${idx} OR c.instructor ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await pool.query(`SELECT COUNT(*) FROM courses c ${where}`, values);
    values.push(limit, offset);

    const result = await pool.query(
      `SELECT c.*,
              COUNT(ce.id)::int AS enrolled_count
       FROM courses c
       LEFT JOIN course_enrollments ce ON ce.course_id = c.id
       ${where}
       GROUP BY c.id
       ORDER BY c.rating DESC
       LIMIT $${idx++} OFFSET $${idx}`,
      values
    );

    res.json({
      success: true,
      total: parseInt(countResult.rows[0].count),
      page: parseInt(page),
      courses: result.rows,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single course
// @route   GET /api/courses/:id
// @access  Public
const getCourseById = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT c.*,
              COUNT(ce.id)::int AS enrolled_count
       FROM courses c
       LEFT JOIN course_enrollments ce ON ce.course_id = c.id
       WHERE c.id = $1
       GROUP BY c.id`,
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Course not found.' });
    }

    res.json({ success: true, course: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Enroll in a course
// @route   POST /api/courses/:id/enroll
// @access  Private
const enrollCourse = async (req, res, next) => {
  try {
    const { id } = req.params;

    const courseCheck = await pool.query('SELECT id, title FROM courses WHERE id = $1 AND is_active = true', [id]);
    if (courseCheck.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Course not found.' });
    }

    const existing = await pool.query(
      'SELECT id FROM course_enrollments WHERE user_id = $1 AND course_id = $2',
      [req.user.id, id]
    );
    if (existing.rows.length > 0) {
      return res.status(400).json({ success: false, message: 'You are already enrolled in this course.' });
    }

    await pool.query(
      'INSERT INTO course_enrollments (user_id, course_id) VALUES ($1, $2)',
      [req.user.id, id]
    );

    res.status(201).json({
      success: true,
      message: `Successfully enrolled in "${courseCheck.rows[0].title}"!`,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get my enrolled courses
// @route   GET /api/courses/my-courses
// @access  Private
const getMyCourses = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT c.*, ce.progress, ce.completed, ce.enrolled_at
       FROM course_enrollments ce
       JOIN courses c ON c.id = ce.course_id
       WHERE ce.user_id = $1
       ORDER BY ce.enrolled_at DESC`,
      [req.user.id]
    );

    res.json({ success: true, courses: result.rows });
  } catch (err) {
    next(err);
  }
};

// @desc    Update course progress
// @route   PUT /api/courses/:id/progress
// @access  Private
const updateProgress = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { progress } = req.body;

    if (progress === undefined || progress < 0 || progress > 100) {
      return res.status(400).json({ success: false, message: 'Progress must be between 0 and 100.' });
    }

    const result = await pool.query(
      `UPDATE course_enrollments
       SET progress = $1, completed = $2
       WHERE user_id = $3 AND course_id = $4
       RETURNING *`,
      [progress, progress === 100, req.user.id, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Enrollment not found. Enroll first.' });
    }

    res.json({ success: true, enrollment: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

module.exports = { getCourses, getCourseById, enrollCourse, getMyCourses, updateProgress };
