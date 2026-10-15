(function () {
  'use strict';

  function initImageCompare() {
    const links = Array.from(document.querySelectorAll('.image-compare[src]'));
    if (links.length === 0 || typeof HTMLDialogElement === 'undefined') return;

    const dialog = document.createElement('dialog');
    dialog.className = 'image-compare-dialog';
    dialog.setAttribute('aria-label', 'Image comparison');
    dialog.innerHTML = `
      <div class="image-compare-dialog__body">
        <div class="image-compare-dialog__frame">
          <img class="image-compare-dialog__image" alt="">
          <p class="image-compare-dialog__status" role="status" aria-live="polite"></p>
        </div>
        <div class="image-compare-dialog__toolbar">
          <p class="image-compare-dialog__caption"></p>
          <span class="image-compare-dialog__keyboard-hint">Press Space to pause and switch manually. Click to close.</span>
          <button type="button" data-action="toggle" aria-label="Pause animation">Pause</button>
          <span data-role="counter" aria-live="polite">1/2</span>
        </div>
      </div>`;
    document.body.appendChild(dialog);

    const image = dialog.querySelector('.image-compare-dialog__image');
    const caption = dialog.querySelector('.image-compare-dialog__caption');
    const status = dialog.querySelector('.image-compare-dialog__status');
    const counter = dialog.querySelector('[data-role="counter"]');
    const toggle = dialog.querySelector('[data-action="toggle"]');
    const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
    let activeLink = null;
    let images = [];
    let frame = 0;
    let timer = null;
    let paused = reducedMotion.matches;

    function stopTimer() {
      if (timer !== null) {
        window.clearInterval(timer);
        timer = null;
      }
    }

    function updateControls() {
      counter.textContent = `${frame + 1}/2`;
      toggle.textContent = paused ? 'Play' : 'Pause';
      toggle.setAttribute('aria-label', `${paused ? 'Resume' : 'Pause'} animation`);
    }

    function showFrame(nextFrame) {
      frame = nextFrame;
      image.src = images[frame].src;
      image.alt = images[frame].alt || `Comparison image ${frame + 1}`;
      updateControls();
    }

    function selectFrame(nextFrame) {
      paused = true;
      stopTimer();
      showFrame(nextFrame);
    }

    function startTimer() {
      stopTimer();
      if (!paused && dialog.open) {
        timer = window.setInterval(() => showFrame((frame + 1) % 2), 1000);
      }
    }

    function closeDialog() {
      stopTimer();
      if (dialog.open) dialog.close();
      if (activeLink) activeLink.focus();
    }

    async function openComparison(link) {
      activeLink = link;
      const sources = [link.href, new URL(link.getAttribute('src'), link.href).href];
      const preview = link.querySelector('img');
      images = sources.map(src => new Image());
      frame = 0;
      paused = reducedMotion.matches;
      caption.textContent = preview ? preview.alt : '';
      status.textContent = 'Loading images...';
      image.removeAttribute('src');
      dialog.showModal();

      try {
        await Promise.all(images.map((item, index) => new Promise((resolve, reject) => {
          item.onload = resolve;
          item.onerror = reject;
          item.src = sources[index];
        })));
        status.textContent = '';
        showFrame(0);
        startTimer();
      } catch (error) {
        stopTimer();
        status.textContent = 'Unable to load comparison images.';
      }
    }

    links.forEach(link => {
      const preview = link.querySelector('img');
      if (preview && preview.alt && !link.querySelector('.image-compare__caption')) {
        const previewCaption = document.createElement('span');
        previewCaption.className = 'image-compare__caption';
        previewCaption.setAttribute('aria-hidden', 'true');
        previewCaption.textContent = preview.alt;
        link.appendChild(previewCaption);
      }

      link.addEventListener('click', event => {
        event.preventDefault();
        openComparison(link);
      });
    });

    dialog.addEventListener('click', event => {
      if (!event.target.closest('.image-compare-dialog__toolbar')) closeDialog();
    });
    dialog.addEventListener('keydown', event => {
      if (event.code !== 'Space') return;
      event.preventDefault();
      event.stopPropagation();
      selectFrame((frame + 1) % 2);
    });
    toggle.addEventListener('click', () => {
      paused = !paused;
      startTimer();
      updateControls();
    });
    dialog.addEventListener('cancel', event => {
      event.preventDefault();
      closeDialog();
    });
    document.addEventListener('visibilitychange', () => {
      if (document.hidden) stopTimer();
      else if (dialog.open) startTimer();
    });
    reducedMotion.addEventListener?.('change', event => {
      paused = event.matches;
      startTimer();
      updateControls();
    });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initImageCompare);
  else initImageCompare();
}());