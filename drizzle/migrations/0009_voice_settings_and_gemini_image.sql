UPDATE public.ai_providers SET enabled = true, updated_at = now() WHERE id IN ('edge-tts','kokoro');
INSERT INTO public.ai_settings (key, value, updated_at)
VALUES ('voice_engines', '{"ids":["edge-tts","kokoro"]}'::jsonb, now())
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now();

insert into public.ai_providers (id, category, label, tier, zero_cost, requires_key, enabled, sort_order) values
  ('gemini-image', 'image', 'Google Gemini 2.5 Flash Image (Free)', 'free', true, true, true, 0)
on conflict (id) do update set label = excluded.label, tier = excluded.tier, zero_cost = excluded.zero_cost, requires_key = excluded.requires_key, enabled = true, sort_order = excluded.sort_order;

update public.ai_settings
set value = jsonb_set(value, '{image}', '"gemini-image"'::jsonb)
where key = 'defaults';