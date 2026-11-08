-- EasyPass Supabase setup
-- Run this in Supabase Dashboard -> SQL Editor.
-- Before running it, create a Storage bucket named: resources
-- Make that bucket PUBLIC because students must be able to download files for free.

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.resources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  level text not null check (level in ('Level 100','Level 200','Level 300','Level 400')),
  type text not null check (type in ('Past Questions','Study Notes','Lecture Slides','Other')),
  subject text,
  course text,
  year text,
  file_url text not null,
  storage_path text not null unique,
  created_at timestamptz not null default now()
);

create index if not exists resources_level_idx on public.resources(level);
create index if not exists resources_type_idx on public.resources(type);
create index if not exists resources_created_at_idx on public.resources(created_at desc);

-- Helper used by RLS policies. It is intentionally not exposed as a client table.
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

alter table public.admin_users enable row level security;
alter table public.resources enable row level security;

-- Public visitors can read resources.
drop policy if exists "Public can read resources" on public.resources;
create policy "Public can read resources"
on public.resources
for select
to anon, authenticated
using (true);

-- Only an administrator can create/edit/delete resource records.
drop policy if exists "Admins can insert resources" on public.resources;
create policy "Admins can insert resources"
on public.resources
for insert
to authenticated
with check ((select public.is_admin()));

drop policy if exists "Admins can update resources" on public.resources;
create policy "Admins can update resources"
on public.resources
for update
to authenticated
using ((select public.is_admin()))
with check ((select public.is_admin()));

drop policy if exists "Admins can delete resources" on public.resources;
create policy "Admins can delete resources"
on public.resources
for delete
to authenticated
using ((select public.is_admin()));

-- Do not expose admin_users to normal visitors.
-- The site checks admin status through is_admin() and the authenticated user's query.
drop policy if exists "Admins can read admin_users" on public.admin_users;
create policy "Admins can read admin_users"
on public.admin_users
for select
to authenticated
using ((select public.is_admin()));

-- STORAGE POLICIES
-- The bucket itself should be PUBLIC. Public files can be downloaded by students.
-- These policies control who may upload/update/delete objects.

drop policy if exists "Admins can upload resources" on storage.objects;
create policy "Admins can upload resources"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'resources'
  and (select public.is_admin())
);

drop policy if exists "Admins can update resource files" on storage.objects;
create policy "Admins can update resource files"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'resources'
  and (select public.is_admin())
)
with check (
  bucket_id = 'resources'
  and (select public.is_admin())
);

drop policy if exists "Admins can delete resource files" on storage.objects;
create policy "Admins can delete resource files"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'resources'
  and (select public.is_admin())
);

-- IMPORTANT:
-- Do not put a Supabase service_role/secret key in index.html, admin.html, config.js,
-- GitHub, or any browser-visible file.
