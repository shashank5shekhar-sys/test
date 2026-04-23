-- ============================================================
--  QuizMaster — Supabase Database Setup
--  Run this entire script in your Supabase SQL Editor
-- ============================================================

-- ── 1. PROFILES ──────────────────────────────────────────────────────────────
create table if not exists profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  email       text not null,
  name        text not null default 'Student',
  phone       text,
  avatar_url  text,
  created_at  timestamptz default now()
);

alter table profiles enable row level security;

create policy "Users can view own profile"
  on profiles for select using (auth.uid() = id);

create policy "Users can update own profile"
  on profiles for update using (auth.uid() = id);

create policy "Users can insert own profile"
  on profiles for insert with check (auth.uid() = id);


-- ── 2. QUIZZES ────────────────────────────────────────────────────────────────
create table if not exists quizzes (
  id               uuid primary key default gen_random_uuid(),
  title            text not null,
  description      text not null default '',
  category         text not null default 'General',
  total_questions  int  not null default 5,
  icon_emoji       text not null default '📚',
  created_at       timestamptz default now()
);

alter table quizzes enable row level security;

create policy "Anyone can read quizzes"
  on quizzes for select using (true);


-- ── 3. QUESTIONS ─────────────────────────────────────────────────────────────
create table if not exists questions (
  id             uuid primary key default gen_random_uuid(),
  quiz_id        uuid not null references quizzes(id) on delete cascade,
  question_text  text not null,
  options        jsonb not null,          -- array of 4 strings
  correct_index  int  not null default 0, -- 0-based index into options
  order_num      int  not null default 0,
  created_at     timestamptz default now()
);

alter table questions enable row level security;

create policy "Anyone can read questions"
  on questions for select using (true);


-- ── 4. QUIZ RESULTS ───────────────────────────────────────────────────────────
create table if not exists quiz_results (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid references auth.users(id) on delete set null,
  quiz_id           uuid references quizzes(id) on delete set null,
  quiz_title        text,
  score             int  not null,
  total             int  not null,
  passed            boolean not null default false,
  participant_name  text,
  participant_phone text,
  created_at        timestamptz default now()
);

alter table quiz_results enable row level security;

create policy "Users can insert own results"
  on quiz_results for insert with check (auth.uid() = user_id);

create policy "Users can view own results"
  on quiz_results for select using (auth.uid() = user_id);


-- ── 5. STORAGE BUCKET ─────────────────────────────────────────────────────────
-- Run in Supabase Dashboard → Storage → New Bucket
-- Name: avatars  |  Public: true
-- OR run via SQL:

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

create policy "Avatar images are publicly accessible"
  on storage.objects for select
  using (bucket_id = 'avatars');

create policy "Users can upload their own avatar"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Users can update their own avatar"
  on storage.objects for update
  using (
    bucket_id = 'avatars' and
    auth.uid()::text = (storage.foldername(name))[1]
  );


-- ── 6. SEED DATA — 5 Quizzes × 5 Questions each ──────────────────────────────

-- Quiz 1: General Knowledge
insert into quizzes (id, title, description, category, total_questions, icon_emoji) values
('11111111-0000-0000-0000-000000000001', 'General Knowledge', 'Test your everyday knowledge', 'General', 5, '🌍');

insert into questions (quiz_id, question_text, options, correct_index, order_num) values
('11111111-0000-0000-0000-000000000001', 'What is the capital of France?',
 '["Paris","London","Berlin","Madrid"]', 0, 1),
('11111111-0000-0000-0000-000000000001', 'Which planet is known as the Red Planet?',
 '["Venus","Mars","Jupiter","Saturn"]', 1, 2),
('11111111-0000-0000-0000-000000000001', 'Who wrote "Romeo and Juliet"?',
 '["Charles Dickens","William Shakespeare","Jane Austen","Mark Twain"]', 1, 3),
('11111111-0000-0000-0000-000000000001', 'How many continents are there on Earth?',
 '["5","6","7","8"]', 2, 4),
('11111111-0000-0000-0000-000000000001', 'What is the largest ocean?',
 '["Atlantic","Indian","Arctic","Pacific"]', 3, 5);


-- Quiz 2: Science & Nature
insert into quizzes (id, title, description, category, total_questions, icon_emoji) values
('22222222-0000-0000-0000-000000000002', 'Science & Nature', 'Explore the wonders of science', 'Science', 5, '🔬');

insert into questions (quiz_id, question_text, options, correct_index, order_num) values
('22222222-0000-0000-0000-000000000002', 'What is the chemical symbol for water?',
 '["WA","H2O","HO","O2H"]', 1, 1),
('22222222-0000-0000-0000-000000000002', 'What is the speed of light (approx)?',
 '["300,000 km/s","150,000 km/s","450,000 km/s","600,000 km/s"]', 0, 2),
('22222222-0000-0000-0000-000000000002', 'How many bones are in the adult human body?',
 '["196","206","216","226"]', 1, 3),
('22222222-0000-0000-0000-000000000002', 'What gas do plants absorb from the atmosphere?',
 '["Oxygen","Nitrogen","Carbon Dioxide","Hydrogen"]', 2, 4),
('22222222-0000-0000-0000-000000000002', 'What is the powerhouse of the cell?',
 '["Nucleus","Ribosome","Mitochondria","Golgi Apparatus"]', 2, 5);


-- Quiz 3: Mathematics
insert into quizzes (id, title, description, category, total_questions, icon_emoji) values
('33333333-0000-0000-0000-000000000003', 'Mathematics', 'Sharp your mathematical skills', 'Math', 5, '🔢');

insert into questions (quiz_id, question_text, options, correct_index, order_num) values
('33333333-0000-0000-0000-000000000003', 'What is the value of π (pi) to 2 decimal places?',
 '["3.12","3.14","3.16","3.18"]', 1, 1),
('33333333-0000-0000-0000-000000000003', 'What is 12 × 12?',
 '["124","134","144","154"]', 2, 2),
('33333333-0000-0000-0000-000000000003', 'What is the square root of 144?',
 '["11","12","13","14"]', 1, 3),
('33333333-0000-0000-0000-000000000003', 'What is 15% of 200?',
 '["25","30","35","40"]', 1, 4),
('33333333-0000-0000-0000-000000000003', 'If a triangle has angles of 60° and 80°, what is the third angle?',
 '["30°","40°","50°","60°"]', 1, 5);


-- Quiz 4: Technology
insert into quizzes (id, title, description, category, total_questions, icon_emoji) values
('44444444-0000-0000-0000-000000000004', 'Technology', 'Test your tech knowledge', 'Tech', 5, '💻');

insert into questions (quiz_id, question_text, options, correct_index, order_num) values
('44444444-0000-0000-0000-000000000004', 'What does CPU stand for?',
 '["Central Processing Unit","Computer Personal Unit","Central Program Unit","Core Processing Unit"]', 0, 1),
('44444444-0000-0000-0000-000000000004', 'Which programming language is known as the language of the web (frontend)?',
 '["Python","Java","JavaScript","C++"]', 2, 2),
('44444444-0000-0000-0000-000000000004', 'What does HTML stand for?',
 '["HyperText Markup Language","High Transfer Markup Language","HyperText Modeling Language","Home Tool Markup Language"]', 0, 3),
('44444444-0000-0000-0000-000000000004', 'Who founded Microsoft?',
 '["Steve Jobs","Elon Musk","Bill Gates","Mark Zuckerberg"]', 2, 4),
('44444444-0000-0000-0000-000000000004', 'What does RAM stand for?',
 '["Read Access Memory","Random Access Memory","Run Active Memory","Rapid Access Module"]', 1, 5);


-- Quiz 5: History
insert into quizzes (id, title, description, category, total_questions, icon_emoji) values
('55555555-0000-0000-0000-000000000005', 'World History', 'Journey through time', 'History', 5, '🏛️');

insert into questions (quiz_id, question_text, options, correct_index, order_num) values
('55555555-0000-0000-0000-000000000005', 'In which year did World War II end?',
 '["1943","1944","1945","1946"]', 2, 1),
('55555555-0000-0000-0000-000000000005', 'Who was the first President of the United States?',
 '["Abraham Lincoln","Thomas Jefferson","George Washington","John Adams"]', 2, 2),
('55555555-0000-0000-0000-000000000005', 'Which ancient wonder was located in Alexandria?',
 '["Colosseum","Great Pyramid","Lighthouse of Alexandria","Hanging Gardens"]', 2, 3),
('55555555-0000-0000-0000-000000000005', 'The French Revolution began in which year?',
 '["1769","1779","1789","1799"]', 2, 4),
('55555555-0000-0000-0000-000000000005', 'Who was the first human to travel to space?',
 '["Neil Armstrong","Buzz Aldrin","Yuri Gagarin","Alan Shepard"]', 2, 5);
