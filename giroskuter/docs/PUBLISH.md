# Как опубликовать проект на GitHub

Инструкция на 5 минут. Нужен аккаунт GitHub и установленный `git` (у вас уже установлен).

## 1. Создать пустой репозиторий

1. Открыть [github.com/new](https://github.com/new).
2. **Repository name:** `my-giro`.
3. **Public** (иначе GitHub Pages не включится на бесплатном тарифе).
4. **Не** ставить галочки «Add a README», «Add .gitignore» — репозиторий должен быть пустым.
5. **Create repository**.

## 2. Привязать удалённый репозиторий и отправить ветки

В папке проекта (там, где лежит `index.html` и папка `.git`):

```bash
git remote add origin https://github.com/USERNAME/my-giro.git
git push -u origin main design layout gh-pages
```

`USERNAME` замените на свой логин. Если git попросит пароль — вставляйте
**Personal Access Token** (GitHub → Settings → Developer settings → Personal access
tokens → Generate new token, права `repo`), обычный пароль не подойдёт.

То же самое можно сделать одной командой из PowerShell:

```powershell
.\publish.ps1 -Repo "https://github.com/USERNAME/my-giro.git"
```

## 3. Включить GitHub Pages

1. В репозитории: **Settings → Pages**.
2. **Source:** `Deploy from a branch`.
3. **Branch:** `gh-pages` · **folder:** `/ (root)` → **Save**.
4. Через 1–2 минуты сайт откроется по адресу
   `https://USERNAME.github.io/my-giro/`.

## 4. Что сдать

1. Ссылка на репозиторий (там видны все ветки):
   `https://github.com/USERNAME/my-giro`
2. Ссылка на опубликованную страницу:
   `https://USERNAME.github.io/my-giro/`

## Если что-то пошло не так

| Проблема | Решение |
|---|---|
| `remote origin already exists` | `git remote set-url origin https://github.com/USERNAME/my-giro.git` |
| `Authentication failed` | вместо пароля — Personal Access Token |
| Страница 404 | проверить, что Pages включён именно для ветки `gh-pages`, и подождать 2 минуты |
| Картинки не грузятся на сайте | проверить, что папка `images` попала в ветку `gh-pages` |
| После правок вёрстки сайт не обновился | `git checkout gh-pages`, затем `git merge layout` и `git push` |

## Порядок работы с ветками

```
main ──► design   (макет, логотип, UI-кит)
     └─► layout   (вёрстка)
              └─► gh-pages  (публикация; обновляется слиянием из layout)
```

Обновить опубликованную версию после правок:

```bash
git checkout layout
# ... правки ...
git add . && git commit -m "правки вёрстки"
git checkout gh-pages
git merge layout
git push
```
