# EasyPass Full Platform

EasyPass is a beginner-friendly College of Education resource website with:

- Public homepage
- Free student downloads
- Levels 100, 200, 300 and 400
- Search and filters
- Admin login
- Admin-only resource uploads
- Admin-only deletion
- Supabase database + Storage
- Free/static hosting compatible with GitHub Pages

## Architecture

Browser (HTML/CSS/JS)
        |
        +---- Supabase Auth (admin login)
        |
        +---- Supabase Postgres (resource records)
        |
        +---- Supabase Storage (PDF/doc files)

Students do not need accounts.

## Setup

1. Create a Supabase project.
2. In Storage, create a bucket named `resources`.
3. Make the bucket public.
4. Open SQL Editor and run `schema.sql`.
5. Create your first admin user in Authentication -> Users.
6. Copy that user's UUID.
7. In SQL Editor run:

   insert into public.admin_users (user_id)
   values ('PASTE-YOUR-USER-UUID-HERE');

8. Open Supabase Project Settings -> API and copy the Project URL and Publishable/Anon key.
9. Put those values in `config.js`:

   const SUPABASE_URL = "https://YOUR-PROJECT.supabase.co";
   const SUPABASE_PUBLISHABLE_KEY = "YOUR-PUBLISHABLE-OR-ANON-KEY";

10. Test locally by opening the site with a simple local server. A beginner-friendly option is VS Code + Live Server.
11. Publish the files to GitHub Pages.

## GitHub Pages

Create a public repository on GitHub (GitHub Free supports Pages for public repositories). Put:
- index.html
- admin.html
- config.js
- styles.css

in the repository root. Then enable Settings -> Pages -> Deploy from branch -> main -> /(root).

## Supabase Auth settings

For local testing, your browser page must be allowed by your Supabase Auth URL settings if you use email confirmation or password reset.

After GitHub Pages gives you a site address, add that address under the Supabase Auth URL configuration as an allowed redirect/site URL if needed.

## Adding resources

You no longer edit a resource list manually.

1. Open `/admin.html`.
2. Sign in with the admin email/password.
3. Enter the title, level, type, subject and year.
4. Select the file.
5. Click Upload & Publish.

The file goes to the `resources` Storage bucket and the metadata goes into the `resources` database table.

## Security

- Only the publishable/anon key belongs in browser code.
- Never put a `service_role` or secret key in the browser.
- Database and Storage permissions are enforced with Row Level Security.
- Students can read resource metadata and download public resource files.
- Only users listed in `admin_users` can upload/delete resources.

## Free-tier note

Supabase and GitHub Pages offer free options, but quotas, limits and policies can change. Check the current provider dashboard before relying on the free tier for large files or high traffic.

## Copyright

Only upload material you have permission to distribute. Past examination papers, lecture notes and other educational documents may be copyrighted. Obtain permission where necessary and follow your institution's rules.
