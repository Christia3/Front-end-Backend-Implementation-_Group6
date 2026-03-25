# MobiLedger Backend API

A complete REST API backend for the **MobiLedger** farming marketplace Flutter app.

## Tech Stack
- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** PostgreSQL
- **Auth:** JWT (JSON Web Tokens)
- **File uploads:** Multer

---

## Project Structure

```
backend/
├── server.js                  ← Entry point
├── .env.example               ← Environment variable template
├── package.json
├── config/
│   ├── db.js                  ← PostgreSQL connection pool
│   ├── migrate.js             ← Creates all database tables
│   └── seed.js                ← Populates sample data
├── middleware/
│   ├── auth.js                ← JWT authentication guard
│   ├── errorHandler.js        ← Global error handler
│   └── upload.js              ← Multer image upload config
├── controllers/
│   ├── authController.js      ← Register, login, forgot password
│   ├── userController.js      ← Profile, settings, password change
│   ├── shopController.js      ← Shop CRUD
│   ├── productController.js   ← Product CRUD
│   ├── cartController.js      ← Cart management
│   ├── orderController.js     ← Order placement & tracking
│   ├── creditController.js    ← Credit balance & transactions
│   └── courseController.js    ← Learn Hub courses
├── routes/
│   ├── authRoutes.js
│   ├── userRoutes.js
│   ├── shopRoutes.js
│   ├── productRoutes.js
│   ├── cartRoutes.js
│   ├── orderRoutes.js
│   ├── creditRoutes.js
│   └── courseRoutes.js
└── api_service.dart           ← Flutter Dart API client (copy to your app)
```

---

## Setup Instructions

### 1. Prerequisites
- Node.js v18+
- PostgreSQL v14+

### 2. Install dependencies
```bash
cd backend
npm install
```

### 3. Configure environment
```bash
cp .env.example .env
```
Edit `.env` and fill in your PostgreSQL credentials:
```env
PORT=5000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=mobiledger_db
DB_USER=postgres
DB_PASSWORD=postgres
JWT_SECRET=change_this_to_a_long_random_string
```

### 4. Create the database
```bash
psql -U postgres -c "CREATE DATABASE mobiledger_db;"
```

### 5. Run migrations (create tables)
```bash
npm run db:migrate
```

### 6. Seed sample data (optional)
```bash
npm run db:seed
```
This creates 3 test users:
| Email | Password |
|-------|----------|
| john@example.com | password123 |
| alice@example.com | password123 |
| admin@mobiledger.com | password123 |

### 7. Start the server
```bash
# Development (auto-restart on changes)
npm run dev

# Production
npm start
```

The API will be running at: **http://localhost:5000**

---

## Connecting Flutter to the Backend

### 1. Add `http` package to `pubspec.yaml`
```yaml
dependencies:
  http: ^1.2.0
  shared_preferences: ^2.2.1
```

### 2. Copy `api_service.dart` to your Flutter project
Place it at: `my_app/lib/services/api_service.dart`

### 3. Update the base URL in `api_service.dart`
```dart
// Android emulator → use 10.0.2.2
const String BASE_URL = 'http://10.0.2.2:5000/api';

// iOS simulator → use localhost
const String BASE_URL = 'http://localhost:5000/api';

// Physical device → use your machine's local IP
const String BASE_URL = 'http://192.168.1.x:5000/api';
```

### 4. Usage example in Flutter screens
```dart
import '../services/api_service.dart';

// Login
final result = await ApiService.login(email: 'john@example.com', password: 'password123');
if (result['success'] == true) {
  // Navigate to dashboard
}

// Get shops
final shopsResult = await ApiService.getShops(category: 'Vegetables');
final shops = shopsResult['shops'] as List;

// Add to cart
await ApiService.addToCart(productId, quantity: 2);

// Place order
await ApiService.placeOrder(
  shippingName: 'John Doe',
  shippingAddress: '123 Farm Road',
  paymentMethod: 'Mobile Money',
);
```

---

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login |
| POST | `/api/auth/forgot-password` | Request password reset |
| GET | `/api/auth/me` | Get current user (🔒) |

### Users
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users/profile` | Get profile + stats (🔒) |
| PUT | `/api/users/profile` | Update profile (🔒) |
| PUT | `/api/users/settings` | Update settings (🔒) |
| PUT | `/api/users/change-password` | Change password (🔒) |

### Shops
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/shops` | List shops (search, category filter) |
| GET | `/api/shops/:id` | Shop details + products |
| GET | `/api/shops/me/my-shop` | My shop (🔒) |
| POST | `/api/shops` | Create shop (🔒) |
| PUT | `/api/shops/:id` | Update shop (🔒) |

### Products
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/products` | List products (filters) |
| GET | `/api/products/:id` | Product details |
| GET | `/api/products/me/my-products` | My products (🔒) |
| POST | `/api/products` | Add product (🔒) |
| PUT | `/api/products/:id` | Edit product (🔒) |
| DELETE | `/api/products/:id` | Delete product (🔒) |

### Cart
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/cart` | Get cart (🔒) |
| POST | `/api/cart` | Add item (🔒) |
| PUT | `/api/cart/:id` | Update quantity (🔒) |
| DELETE | `/api/cart/:id` | Remove item (🔒) |
| DELETE | `/api/cart` | Clear cart (🔒) |

### Orders
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/orders` | Place order from cart (🔒) |
| GET | `/api/orders` | My orders (🔒) |
| GET | `/api/orders/sales` | My sales as seller (🔒) |
| GET | `/api/orders/:id` | Order details (🔒) |
| PUT | `/api/orders/:id/status` | Update order status (🔒) |

### Credits
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/credits` | Balance + recent transactions (🔒) |
| GET | `/api/credits/transactions` | All transactions (🔒) |
| POST | `/api/credits/transfer` | Transfer credits (🔒) |
| POST | `/api/credits/redeem` | Redeem credits (🔒) |

### Courses
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/courses` | List courses |
| GET | `/api/courses/:id` | Course details |
| GET | `/api/courses/me/my-courses` | My enrollments (🔒) |
| POST | `/api/courses/:id/enroll` | Enroll (🔒) |
| PUT | `/api/courses/:id/progress` | Update progress (🔒) |

🔒 = Requires `Authorization: Bearer <token>` header
