create table if not exists public.gemini_keys (
  id uuid primary key default gen_random_uuid(),
  label text not null default 'Gemini key',
  api_key text not null,
  active boolean not null default true,
  failures integer not null default 0,
  last_used_at timestamptz,
  created_at timestamptz not null default now()
);

grant all on public.gemini_keys to service_role;

alter table public.gemini_keys enable row level security;