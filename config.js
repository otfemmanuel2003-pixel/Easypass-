// EasyPass configuration
// IMPORTANT: Use the Supabase PUBLISHABLE/ANON key here, never a secret/service_role key.
const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_PUBLISHABLE_KEY = "YOUR_SUPABASE_PUBLISHABLE_KEY";

const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_PUBLISHABLE_KEY
);

const STORAGE_BUCKET = "resources";
