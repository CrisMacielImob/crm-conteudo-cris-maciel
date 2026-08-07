-- Central de Conteudo, Cris Maciel
-- Schema Supabase (Postgres). Rode este arquivo inteiro no SQL Editor do
-- projeto Supabase (Database > SQL Editor > New query > Run).

create extension if not exists "pgcrypto";

-- ---------- CARDS ----------
create table if not exists public.cards (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  classificacoes text[] not null default '{}',
  corretor text default '',
  codigo text default '',
  data_gravacao date,
  areas jsonb not null default '[]',       -- [{ rede, data }]
  pub_hora text default '',
  link text default '',
  obs text default '',
  checklist jsonb not null default '[]',   -- [{ text, done }]
  stage integer not null default 0,
  archived boolean not null default false,
  created_at timestamptz not null default now(),
  agendado_at timestamptz,
  gravado_at timestamptz,
  entregue_at timestamptz,
  postado_at timestamptz,
  delivery_status text,
  delivery_days integer
);

-- ---------- IDEIAS ----------
create table if not exists public.ideas (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  formato text default '',
  prioridade text default 'Media',
  descricao text default '',
  referencia text default '',
  created_at timestamptz not null default now()
);

-- ---------- REALTIME ----------
-- Habilita a replicacao das duas tabelas para o canal realtime do Supabase,
-- assim as mudancas de um navegador aparecem no outro sem precisar recarregar.
alter publication supabase_realtime add table public.cards;
alter publication supabase_realtime add table public.ideas;

-- ---------- RLS ----------
-- Sem login: qualquer pessoa com a URL e a chave anon do projeto le e
-- escreve nessas tabelas. A protecao aqui e a obscuridade da URL do
-- projeto e da chave anon, nao autenticacao de usuario. Se no futuro
-- quiser exigir login, troque estas policies por regras com auth.uid().
alter table public.cards enable row level security;
alter table public.ideas enable row level security;

create policy "cards: leitura publica" on public.cards
  for select using (true);
create policy "cards: escrita publica" on public.cards
  for insert with check (true);
create policy "cards: atualizacao publica" on public.cards
  for update using (true) with check (true);
create policy "cards: exclusao publica" on public.cards
  for delete using (true);

create policy "ideas: leitura publica" on public.ideas
  for select using (true);
create policy "ideas: escrita publica" on public.ideas
  for insert with check (true);
create policy "ideas: atualizacao publica" on public.ideas
  for update using (true) with check (true);
create policy "ideas: exclusao publica" on public.ideas
  for delete using (true);
