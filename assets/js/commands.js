/* global JS for the main commands page */
(function () {
  'use strict';

  /* ------------------------------------------------------------------
     Collapsible descriptions (details/summary with animation)
  ------------------------------------------------------------------ */
  function initCollapsibleDescriptions() {
    document.querySelectorAll('#doc-list details').forEach(function (details) {
      var summary     = details.querySelector('summary');
      var description = details.querySelector('.doc-description');

      summary.addEventListener('click', function (event) {
        // Let real link clicks through
        if (event.target.closest('a')) { return; }

        event.preventDefault();

        if (details.open) {
          var closing = description.animate(
            { height: [description.offsetHeight + 'px', '0px'] },
            { duration: 200, easing: 'ease-out' }
          );
          closing.onfinish = function () { details.removeAttribute('open'); };
        } else {
          details.setAttribute('open', '');
          description.animate(
            { height: ['0px', description.scrollHeight + 'px'] },
            { duration: 200, easing: 'ease-in' }
          );
        }
      });
    });
  }

  /* ------------------------------------------------------------------
     Discipline filter checkboxes
  ------------------------------------------------------------------ */
  function initFilter() {
    var checkboxes = document.querySelectorAll('.filter-checkbox');
    var allItems   = Array.from(document.querySelectorAll('#doc-list li'));

    function apply() {
      var checked = Array.from(checkboxes)
        .filter(function (cb) { return cb.checked; })
        .map(function (cb) { return cb.value; });

      allItems.forEach(function (item) {
        item.style.display = (checked.length === 0 || checked.includes(item.dataset.group))
          ? '' : 'none';
      });
    }

    checkboxes.forEach(function (cb) { cb.addEventListener('change', apply); });
    apply();
  }

  /* ------------------------------------------------------------------
     Ribbon ↔ list mutual hover highlighting
  ------------------------------------------------------------------ */
  function initRibbonHover() {
    var ribbonBtns = document.querySelectorAll('.ribbon-btn[data-slug]');
    var listItems  = document.querySelectorAll('#doc-list li[data-slug]');

    if (ribbonBtns.length === 0) { return; }

    function highlight(slug, on) {
      ribbonBtns.forEach(function (btn) {
        if (btn.dataset.slug === slug) {
          btn.classList.toggle('ribbon-active', on);
        }
      });
      listItems.forEach(function (li) {
        if (li.dataset.slug === slug) {
          li.classList.toggle('ribbon-highlight', on);
        }
      });
    }

    ribbonBtns.forEach(function (btn) {
      var slug = btn.dataset.slug;
      btn.addEventListener('mouseenter', function () { highlight(slug, true); });
      btn.addEventListener('mouseleave', function () { highlight(slug, false); });
    });

    listItems.forEach(function (li) {
      var slug = li.dataset.slug;
      li.addEventListener('mouseenter', function () { highlight(slug, true); });
      li.addEventListener('mouseleave', function () { highlight(slug, false); });
    });
  }

  /* ------------------------------------------------------------------
     Boot
  ------------------------------------------------------------------ */
  document.addEventListener('DOMContentLoaded', function () {
    initCollapsibleDescriptions();
    initFilter();
    initRibbonHover();
  });
}());
