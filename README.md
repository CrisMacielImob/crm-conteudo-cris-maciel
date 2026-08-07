# Central de Conteúdo, Cris Maciel

Ferramenta interna de gestão do pipeline de produção de conteúdo de marketing.
Um único arquivo HTML (`index.html`), sem build, que fala direto com um banco
Supabase para Breno e Nicole verem o mesmo quadro em tempo real.

Sem o Supabase configurado, o app continua funcionando sozinho, salvando só
no navegador local (útil para testar antes de publicar).

## Colocar a nuvem no ar

### 1. Criar o projeto no Supabase

1. Crie uma conta gratuita em supabase.com e um novo projeto.
2. No painel do projeto, abra "SQL Editor", cole o conteúdo de
   `supabase/schema.sql` e rode. Isso cria as tabelas `cards` e `ideas`,
   liga o realtime e libera leitura/escrita sem exigir login.
3. Em "Project Settings" e depois "API", copie a "Project URL" e a chave
   "anon public".
4. Abra `config.js` e preencha:
   ```js
   window.SUPABASE_URL = 'cole a Project URL aqui';
   window.SUPABASE_ANON_KEY = 'cole a chave anon aqui';
   ```

A partir daí, todo mundo que abrir o link publicado enxerga e edita o
mesmo quadro em tempo real.

### 2. Publicar num link fixo

Sem servidor próprio, sem build, é só hospedar o `index.html` (mais
`config.js`) como arquivo estático. Duas opções simples e gratuitas:

**GitHub Pages**
1. Crie um repositório no GitHub e suba este projeto:
   ```bash
   git remote add origin https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
   git push -u origin master
   ```
2. Nas configurações do repositório, aba "Pages", selecione a branch
   `master` e a pasta raiz.
3. O link fica em `https://SEU-USUARIO.github.io/SEU-REPOSITORIO/`.

**Vercel ou Netlify**
1. Conecte o repositório do GitHub direto no painel do Vercel ou Netlify.
2. Não precisa configurar build nem comando de start, é um site estático.
3. Cada um desses serviços gera um link fixo próprio na hora.

### 3. Backup

O botão "Exportar backup" no rodapé continua funcionando mesmo com o
Supabase ligado, gerando um JSON com todos os cards e ideias, como
válvula de escape independente do banco.

## Estrutura

- `index.html`: aplicativo completo (interface, regras de negócio, camada
  de sincronização).
- `config.js`: credenciais do projeto Supabase.
- `supabase/schema.sql`: schema das tabelas, realtime e políticas de acesso.
