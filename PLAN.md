# Work Log

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
