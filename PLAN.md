# Work Log

2025-11-11: Fixed element highlighting
**Problem:** Main page list item hover highlighting was poorly visible when switching to dark theme.
**Solution:** Applied a universal style using a semi-transparent color (rgba) that displays correctly on both light and dark backgrounds.

2025-11-11: Add auto TOC
**Проблема:** На страницах документации отсутствовало оглавление. Кроме того, его заголовок не был переведен для испанской версии.
**Решение:** Изменен центральный скрипт сборки документации. Теперь он автоматически вставляет оглавление с корректным переводом заголовка в зависимости от языка страницы.

2025-11-11: Add collapsible descriptions
**Проблема:** Список команд на главной странице был неинформативен. Чтобы узнать о команде, пользователю приходилось переходить на ее страницу.
**Решение:** Реализованы раскрывающиеся описания с помощью тегов <details>/<summary>. Это потребовало рефакторинга HTML-структуры списка, исправления конфликта в JavaScript и добавления новой функции для плавной анимации.
