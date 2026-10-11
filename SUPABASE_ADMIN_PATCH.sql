-- TREINO ZEDRAX - reforço de segurança para usuários bloqueados
-- Execute no SQL Editor do Supabase uma vez.

create or replace function public.is_active_user()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and status = 'active'
  );
$$;

-- Usuário bloqueado não pode mais ler/gravar histórico/configurações.
drop policy if exists "daily_records_select_own_or_admin" on public.daily_records;
drop policy if exists "daily_records_insert_own" on public.daily_records;
drop policy if exists "daily_records_update_own" on public.daily_records;
drop policy if exists "daily_records_delete_own_or_admin" on public.daily_records;

create policy "daily_records_select_own_or_admin" on public.daily_records
for select using ((user_id = auth.uid() and public.is_active_user()) or public.is_admin());

create policy "daily_records_insert_own" on public.daily_records
for insert with check (user_id = auth.uid() and public.is_active_user());

create policy "daily_records_update_own" on public.daily_records
for update using (user_id = auth.uid() and public.is_active_user())
with check (user_id = auth.uid() and public.is_active_user());

create policy "daily_records_delete_own_or_admin" on public.daily_records
for delete using ((user_id = auth.uid() and public.is_active_user()) or public.is_admin());

drop policy if exists "user_settings_select_own_or_admin" on public.user_settings;
drop policy if exists "user_settings_insert_own" on public.user_settings;
drop policy if exists "user_settings_update_own" on public.user_settings;

create policy "user_settings_select_own_or_admin" on public.user_settings
for select using ((user_id = auth.uid() and public.is_active_user()) or public.is_admin());

create policy "user_settings_insert_own" on public.user_settings
for insert with check (user_id = auth.uid() and public.is_active_user());

create policy "user_settings_update_own" on public.user_settings
for update using (user_id = auth.uid() and public.is_active_user())
with check (user_id = auth.uid() and public.is_active_user());

-- Permite ao ADM excluir uma conta Auth de forma controlada.
create or replace function public.admin_delete_user(target_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  if not public.is_admin() then
    raise exception 'not authorized';
  end if;
  if target_user_id = auth.uid() then
    raise exception 'cannot delete yourself';
  end if;
  delete from auth.users where id = target_user_id;
end;
$$;

revoke all on function public.admin_delete_user(uuid) from public;
grant execute on function public.admin_delete_user(uuid) to authenticated;
