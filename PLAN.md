# Work Log (reversed order)

2026-04-10: Context ribbon redesign — global ±2 window
**Проблема:** На страницах команд контекстная лента показывала все панели целиком (слишком много кнопок).
**Решение:**
- `_includes/ribbon_context.html` переписан: глобальный список всех команд, отсортированных по `ribbon_order`; ищем 0-based индекс текущей команды по `namespace`, берём окно ±2, собираем уникальные панели в окне. Команды с `ribbon_order_2` — 1 позиция, обе кнопки рендерятся сразу. «…» по краям если окно обрезано.
- Структура: `.ribbon-context-row` → группы `.ribbon-context-group` (кнопки сверху + название панели горизонтально по центру снизу) + `ribbon-btn--ellipsis` по краям.
- `commands.css`: убран `max-width: 310px`, добавлен `background-color: #F5F5F5`; новые классы `.ribbon-context-row`, `.ribbon-context-group` (`border-right` разделитель, `min-width: 0`, `:last-of-type { border-right: none }`); override `.ribbon-context .ribbon-panel-name` — горизонтальный текст, без `border-top`, по центру.

2026-04-09: Add ribbon replica + icons
**Решение:**
- `Publish-Docs.ps1` расширен двумя новыми функциями: `Get-RibbonOrder` парсит `App.cs` и строит глобальный порядок кнопок по всем панелям; `Get-ButtonTexts` читает `ButtonText` из `Command*.cs` файлов (с сохранением `\n`). В генерируемый front-matter добавлены поля `ribbon_panel`, `ribbon_order`, `ribbon_separator_before`, `ribbon_button_text`, `icon`. Поле `parent` (дисциплина) теперь берётся из имени панели ленты автоматически. `Logo.png` из `Docs/` копируется в `docs/<slug>/logo.png`.
- Создан `_includes/ribbon.html` — реплика ленты Revit: панели строками, название панели вертикально слева, кнопки с иконкой и подписью (`white-space: pre`, без авто-переноса).
- CSS и JS вынесены из `index.md` в `assets/css/commands.css` и `assets/js/commands.js`. JS разбит на три изолированные функции: `initFilter`, `initCollapsibleDescriptions`, `initRibbonHover`.
- Взаимная подсветка: наведение на кнопку ленты ↔ строку списка через `data-slug`.
- Создана страница дисциплины `docs/4Misc.md`; в `en.yml` и `es.yml` добавлены ключи `misc`.
- Цвета ленты зафиксированы: фон `#F5F5F5`, hover `#DDDDDD`, текст `#1a1a1a`.

2025-11-12: Add collapsible descriptions
**Решение:** Реализованы раскрывающиеся описания на главной странице.

2025-11-11: Automate description generation
**Решение:** Скрипт `Publish-Docs.ps1` был обновлен. Теперь он автоматически извлекает первый параграф из файлов `En.md` и `Es.md` для каждой команды и вставляет его в качестве описания в метаданные генерируемой страницы.

2025-11-11: Add auto TOC
**Проблема:** На страницах документации отсутствовало оглавление. Кроме того, его заголовок не был переведен для испанской версии.
**Решение:** Изменен центральный скрипт сборки документации. Теперь он автоматически вставляет оглавление с корректным переводом заголовка в зависимости от языка страницы.

2025-11-11: Fixed element highlighting
**Problem:** Main page list item hover highlighting was poorly visible when switching to dark theme.
**Solution:** Applied a universal style using a semi-transparent color (rgba) that displays correctly on both light and dark backgrounds.
