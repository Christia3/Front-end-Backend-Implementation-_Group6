const pool = require('./db');
const bcrypt = require('bcryptjs');

const seed = async () => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    // ─── USERS ────────────────────────────────────────────────────────────
    const hashedPassword = await bcrypt.hash('password123', 10);

    const userResult = await client.query(`
      INSERT INTO users (full_name, email, password, phone, address, bio, credits)
      VALUES
        ('John Doe', 'john@example.com', $1, '+250788123456', '123 Farm Road, Kigali', 'Organic farmer since 2010', 1250),
        ('Alice Uwimana', 'alice@example.com', $1, '+250788654321', 'Musanze District', 'Fresh produce supplier', 800),
        ('Admin User', 'admin@mobiledger.com', $1, '+250788000000', 'Kigali', 'Platform administrator', 5000)
      ON CONFLICT (email) DO NOTHING
      RETURNING id, email;
    `, [hashedPassword]);

    console.log(`✅ Seeded ${userResult.rowCount} users`);

    // Get user IDs
    const usersRes = await client.query(`SELECT id, email FROM users WHERE email IN ('john@example.com', 'alice@example.com')`);
    const john = usersRes.rows.find(u => u.email === 'john@example.com');
    const alice = usersRes.rows.find(u => u.email === 'alice@example.com');

    if (!john || !alice) {
      console.log('⚠️  Users already existed, skipping dependent seeds');
      await client.query('COMMIT');
      pool.end();
      return;
    }

    // ─── SHOPS ────────────────────────────────────────────────────────────
    const shopResult = await client.query(`
      INSERT INTO shops (owner_id, name, description, address, phone, email, category, location, rating, total_reviews)
      VALUES
        ($1, 'Green Acres Farm', 'Fresh organic produce from our farm to your table', '123 Farm Road, Kigali', '+250788123456', 'info@greenacres.com', 'Vegetables', 'Kigali', 4.8, 124),
        ($2, 'Sunrise Orchard', 'Premium fruits harvested fresh daily', 'Musanze District', '+250788654321', 'info@sunriseorchard.com', 'Fruits', 'Musanze', 4.9, 98),
        ($1, 'Golden Grain Co', 'Quality grains and cereals', 'Rubavu', '+250788111111', 'info@goldengrain.com', 'Grains', 'Rubavu', 4.5, 67)
      RETURNING id, name;
    `, [john.id, alice.id]);

    const shops = shopResult.rows;
    console.log(`✅ Seeded ${shops.length} shops`);

    // ─── PRODUCTS ─────────────────────────────────────────────────────────
    const productResult = await client.query(`
      INSERT INTO products (shop_id, seller_id, name, description, price, currency, category, stock_quantity, unit)
      VALUES
        ($1, $4, 'Fresh Organic Tomatoes', 'Grown without pesticides, harvested daily', 2500, 'RWF', 'Vegetables', 50, 'kg'),
        ($1, $4, 'Green Cabbage', 'Fresh local cabbage, large heads', 1500, 'RWF', 'Vegetables', 80, 'kg'),
        ($2, $5, 'Ripe Mangoes', 'Sweet and juicy local mangoes', 3000, 'RWF', 'Fruits', 100, 'kg'),
        ($2, $5, 'Passion Fruits', 'Fresh passion fruits from Musanze', 2000, 'RWF', 'Fruits', 60, 'bag'),
        ($3, $4, 'Maize Flour (10kg)', 'Premium quality maize flour', 8000, 'RWF', 'Grains', 200, 'bag'),
        ($3, $4, 'White Rice (5kg)', 'Locally grown white rice', 6000, 'RWF', 'Grains', 150, 'bag')
      RETURNING id, name;
    `, [shops[0].id, shops[1].id, shops[2].id, john.id, alice.id]);

    console.log(`✅ Seeded ${productResult.rowCount} products`);

    // ─── COURSES ──────────────────────────────────────────────────────────
    const courseResult = await client.query(`
      INSERT INTO courses (title, description, instructor, duration, total_lessons, level, category, rating)
      VALUES
        ('Organic Farming 101', 'Learn the basics of organic farming', 'Dr. Sarah Johnson', '2 hours', 12, 'Beginner', 'Farming Basics', 4.8),
        ('Sustainable Agriculture', 'Advanced sustainable farming practices', 'Prof. Michael Green', '3.5 hours', 15, 'Intermediate', 'Organic Methods', 4.9),
        ('Pest Management Strategies', 'Effective pest control without chemicals', 'Emma Watson', '1.5 hours', 8, 'Beginner', 'Pest Control', 4.7),
        ('Advanced Harvesting Techniques', 'Maximize your harvest yield', 'James Brown', '2.5 hours', 10, 'Advanced', 'Harvesting', 4.6),
        ('Farm Marketing & Sales', 'Sell your produce at better prices', 'Grace Uwase', '2 hours', 9, 'Beginner', 'Marketing', 4.5)
      RETURNING id;
    `);

    console.log(`✅ Seeded ${courseResult.rowCount} courses`);

    // ─── CREDIT TRANSACTIONS ──────────────────────────────────────────────
    await client.query(`
      INSERT INTO credit_transactions (user_id, type, amount, description)
      VALUES
        ($1, 'credit', 250, 'Product Sale - Organic Vegetables'),
        ($1, 'debit', 150, 'Fertilizer Purchase'),
        ($1, 'credit', 100, 'Referral Bonus'),
        ($1, 'debit', 75, 'Equipment Rental'),
        ($1, 'credit', 1125, 'Initial Platform Credits')
    `, [john.id]);

    console.log('✅ Seeded credit transactions');

    await client.query('COMMIT');
    console.log('\n🌱 Database seeded successfully!');
    console.log('\nTest credentials:');
    console.log('  Email: john@example.com | Password: password123');
    console.log('  Email: alice@example.com | Password: password123');
    console.log('  Email: admin@mobiledger.com | Password: password123');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('❌ Seed failed:', err.message);
    throw err;
  } finally {
    client.release();
    pool.end();
  }
};

seed().catch(console.error);
