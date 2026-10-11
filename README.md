# TREINO ZEDRAX — versão online

PWA do TREINO ZEDRAX com login Supabase, sincronização de histórico entre dispositivos e área ADM.

## Instalação

O app continua sendo uma PWA: pode ser instalado no celular ou computador pelo navegador, sem precisar publicar uma loja de aplicativos.

## Supabase

- Project URL: `https://iiooyswatrojedzaymfk.supabase.co`
- A chave usada no navegador é uma **Publishable key**. Ela é pública por design; a segurança depende das políticas RLS.
- Nunca coloque uma Secret/Service Role key no HTML.

## Segurança extra

Execute `SUPABASE_ADMIN_PATCH.sql` uma vez no SQL Editor para bloquear o acesso aos dados de contas bloqueadas e habilitar a exclusão de usuários pelo painel ADM.
