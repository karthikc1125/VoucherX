-- Create the wishlists table
CREATE TABLE IF NOT EXISTS public.wishlists (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  brand_name text NOT NULL,
  category text,
  max_price decimal(10,2),
  notify boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

-- 1. Allow users to view their own wishlist items
CREATE POLICY "Users can view own wishlist" ON public.wishlists
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- 2. Allow users to insert their own wishlist items
CREATE POLICY "Users can insert own wishlist" ON public.wishlists
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- 3. Allow users to delete their own wishlist items
CREATE POLICY "Users can delete own wishlist" ON public.wishlists
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);
