# Drift + Supabase Hybrid Database Setup

## Overview

This service delivery app now uses a **hybrid database architecture**:

- **Local**: SQLite (via Drift) - offline-first, persistent storage on Windows
- **Cloud**: Supabase (PostgreSQL) - cloud sync, multi-device support

## Architecture Diagram

```
┌─────────────────────────────────────┐
│     Flutter App (Windows)           │
│  lib/main.dart                      │
└────────────────┬────────────────────┘
                 │
         ┌───────┴────────┐
         │                │
    ┌────▼────┐      ┌────▼──────────┐
    │  Drift  │      │  Supabase     │
    │ (SQLite)│      │  (PostgreSQL) │
    │ Local   │      │  Cloud        │
    │ Storage │      │  Storage      │
    └─────────┘      └───────────────┘
         ▲                   ▲
         └───────┬───────────┘
             Bidirectional Sync
```

## Setup Steps

### 1. Install Dependencies

```bash
cd C:\Users\Administrator\service_delivery_app
flutter pub get
```

### 2. Generate Drift Database Code

```bash
flutter pub run build_runner build
```

This generates `lib/database/database.g.dart` with all queries and table definitions.

### 3. Configure Supabase

**Create a Supabase project** (free tier: https://supabase.com)

**Create tables in Supabase SQL Editor:**

```sql
-- Users table
CREATE TABLE app_users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  role TEXT NOT NULL,
  address TEXT,
  phone TEXT,
  latitude FLOAT,
  longitude FLOAT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Service Orders table
CREATE TABLE service_orders (
  id TEXT PRIMARY KEY,
  customer_id TEXT NOT NULL REFERENCES app_users(id),
  shopper_id TEXT NOT NULL REFERENCES app_users(id),
  title TEXT NOT NULL,
  pickup_address TEXT,
  delivery_address TEXT,
  pickup_lat FLOAT,
  pickup_lng FLOAT,
  delivery_lat FLOAT,
  delivery_lng FLOAT,
  shopper_lat FLOAT,
  shopper_lng FLOAT,
  status TEXT NOT NULL,
  items_list TEXT,
  shopper_rating FLOAT,
  dispute_reason TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create storage bucket for proofs
INSERT INTO storage.buckets (id, name, public)
VALUES ('order-proofs', 'order-proofs', true);
```

**Enable RLS (Row Level Security) if needed:**

```sql
ALTER TABLE app_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_orders ENABLE ROW LEVEL SECURITY;
```

### 4. Update Supabase Credentials

In `lib/database/supabase_sync.dart`, replace:

```dart
await Supabase.initialize(
  url: 'https://your-project.supabase.co',
  anonKey: 'your-anon-key',
);
```

Find your credentials at: https://app.supabase.com/project/[project-id]/settings/api

### 5. Enable Auto-Sync on App Startup

In `lib/main.dart`, add this to `_MainShellState.initState()`:

```dart
@override
void initState() {
  super.initState();

  // Initialize database and sync
  _initializeSync();
}

void _initializeSync() async {
  try {
    await syncService.initialize();
    // Sync immediately on startup
    await syncService.fullSync();

    // Optional: Set up periodic sync every 30 seconds
    Timer.periodic(Duration(seconds: 30), (_) {
      syncService.fullSync();
    });
  } catch (e) {
    print('Sync initialization error: $e');
  }
}
```

## Data Models

### AppUser (Local + Cloud)

```dart
AppUser user = AppUser(
  id: 'user123',
  name: 'John Doe',
  email: 'john@example.com',
  password: 'hashed_password',
  role: 'customer',
  address: '123 Main St',
  phone: '+1-555-1234',
  latitude: 40.7128,
  longitude: -74.0060,
);

// Save locally
await db.insertUser(user);

// Auto-sync to cloud on next sync cycle
```

### ServiceOrder (Local + Cloud)

```dart
ServiceOrder order = ServiceOrder(
  id: 'order123',
  customerId: 'cust1',
  shopperId: 'shop1',
  title: 'Grocery Delivery',
  status: 'inTransit',
  itemsList: jsonEncode(['milk', 'bread']),
  isSynced: false, // Set to true after cloud upload
);

// Save locally
await db.insertOrder(order);

// Will be synced to cloud on next fullSync() call
```

## Key Features

### 1. Offline-First

- App works completely offline using local SQLite database
- No internet required for local operations

### 2. Automatic Sync

- Unsynced orders are tracked with `isSynced` flag
- `fullSync()` syncs in both directions
- Handles sync failures gracefully

### 3. Proof File Storage

- Files stored locally in app documents directory
- Uploaded to Supabase storage during sync
- Can be retrieved via `getProofUrl()` for cloud retrieval

### 4. Multi-Device Support

- Same user logs in on different devices
- Cloud sync pulls latest order data
- Bidirectional conflict resolution

## Database Queries

### Get Orders

```dart
// Get all orders locally
final orders = await db.getAllOrders();

// Get customer's orders
final customerOrders = await db.getOrdersByCustomerId('cust1');

// Get shopper's orders
final shopperOrders = await db.getOrdersByShopperId('shop1');

// Get unsynced orders (not yet uploaded to cloud)
final unsyncedOrders = await db.getUnsyncedOrders();
```

### Update Orders

```dart
// Update order status
final updatedOrder = order.copyWith(
  status: Value('delivered'),
  shopperRating: Value(4.5),
);

await db.updateOrder(updatedOrder);
```

### Proof Files

```dart
// Save proof file reference
final proof = ProofFile(
  orderId: 'order123',
  filePath: '/path/to/file.jpg',
  fileName: 'proof_001.jpg',
  isSynced: false,
);

await db.insertProof(proof);

// Get all proofs for order
final proofs = await db.getOrderProofs('order123');

// Get public URL after synced to cloud
final url = syncService.getProofUrl('order123', 'proof_001.jpg');
```

## Conflict Resolution

When syncing, the app uses **"last write wins"** strategy:

- Local changes overwrite cloud if `updated_at` is newer
- Cloud changes overwrite local if `updated_at` is newer

For custom conflict resolution, modify `syncOrdersFromCloud()` in `supabase_sync.dart`.

## Performance Tips

1. **Batch Operations**: Sync multiple orders at once
2. **Selective Sync**: Only sync orders that changed
3. **Cache Proof URLs**: Store `getProofUrl()` results to avoid repeated calls
4. **Background Sync**: Use Flutter background tasks for periodic sync

## Monitoring & Debugging

### Check Sync Status

```dart
final unsynced = await db.getUnsyncedOrders();
print('Unsynced orders: ${unsynced.length}');
```

### View Local Database

Use `sqlite3` CLI tool:

```bash
sqlite3 ~/Documents/service_delivery.db
SELECT * FROM service_orders;
```

### Cloud Logs

Check Supabase dashboard for API calls and storage uploads.

## Next Steps

1. ✅ Run `flutter pub get` to install all packages
2. ✅ Run `flutter pub run build_runner build` to generate Drift code
3. ✅ Create Supabase project and tables
4. ✅ Update Supabase credentials in `supabase_sync.dart`
5. ✅ Integrate sync service into `main.dart`
6. ✅ Test offline functionality
7. ✅ Test cloud sync with multiple devices

## Troubleshooting

| Issue                       | Solution                                               |
| --------------------------- | ------------------------------------------------------ |
| `database.g.dart` not found | Run `flutter pub run build_runner build`               |
| Supabase auth errors        | Check API URL and anon key in `supabase_sync.dart`     |
| Proof files not uploading   | Ensure storage bucket is public and RLS allows uploads |
| Sync not working offline    | This is expected - sync only works with internet       |
