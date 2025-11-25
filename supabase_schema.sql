-- 1. Create tables
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC NOT NULL,
  category TEXT,
  image_url TEXT,
  seller_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE cart (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  product_id UUID REFERENCES products(id) NOT NULL,
  quantity INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  total_amount NUMERIC NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES orders(id) NOT NULL,
  product_id UUID REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL,
  price NUMERIC NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- 3. Create Policies
-- Allow everyone to read products
CREATE POLICY "Public read products" ON products FOR SELECT USING (true);

-- Allow users to manage their own cart
CREATE POLICY "Users can manage own cart" ON cart FOR ALL USING (auth.uid() = user_id);

-- Allow users to manage their own orders
CREATE POLICY "Users can manage own orders" ON orders FOR ALL USING (auth.uid() = user_id);

-- Allow users to read their own order items
CREATE POLICY "Users can read own order items" ON order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())
);

-- 4. Insert Dummy Data
INSERT INTO products (name, description, price, category, image_url) VALUES
('Margherita Pizza', 'Classic pizza with tomato sauce and mozzarella', 250.0, 'Pizza', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002'),
('Cheeseburger', 'Juicy beef patty with cheese', 180.0, 'Burger', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd'),
('Iced Coffee', 'Cold brewed coffee', 120.0, 'Drinks', 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5'),
('Carbonara Pasta', 'Creamy pasta with bacon and parmesan', 200.0, 'Pasta', 'https://images.unsplash.com/photo-1612874742237-6526221588e3'),
('Chocolate Cake', 'Rich chocolate layer cake', 150.0, 'Desserts', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587');
