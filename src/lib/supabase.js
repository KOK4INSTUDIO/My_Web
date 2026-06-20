import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://hhpzmhvktxdkivobmthb.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhocHptaHZrdHhka2l2b2JtdGhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODExMjM5NDAsImV4cCI6MjA5NjY5OTk0MH0.example-key'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)