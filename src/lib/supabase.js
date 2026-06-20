import { createClient } from '@supabase/supabase-js'

// HARDCODE untuk TESTING (ganti dengan credential kamu!)
const supabaseUrl = 'https://kehgxyjhtkxbauxsdqzz.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRrZWhneHlqa2h0YmF1eHNkcXF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODExMTM5MTAsImV4cCI6MjA5NjY4OTkxMH0.SkswbcE2pkawZA1uMgrsms1-ApkIbBDtXkQbYHOzshM'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)