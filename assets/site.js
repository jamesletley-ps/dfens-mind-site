/* Integrated AI — assets/site.js
   First-party, no dependencies, no network calls. Everything here is
   progressive enhancement: the pages are complete and legible without it.

   1. adds `.js` to <html> so the CSS enhancement layer arms itself
   2. scroll-reveal for section blocks (fails OPEN — see reveal())
*/
(function () {
  'use strict';

  var reduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  document.documentElement.className += ' js';

  function reveal() {
    var nodes = [].slice.call(document.querySelectorAll('[data-reveal]'));
    if (!nodes.length) return;

    function show(n) { n.classList.add('is-in'); }

    if (reduced || typeof IntersectionObserver !== 'function') {
      nodes.forEach(show);
      return;
    }

    var vh = window.innerHeight || 800;
    nodes.forEach(function (n) {
      if (n.getBoundingClientRect().top <= vh * 0.9) show(n);
    });

    var alive = false;
    var io = new IntersectionObserver(function (entries, obs) {
      alive = true;
      entries.forEach(function (e) {
        if (!e.isIntersecting) return;
        show(e.target);
        obs.unobserve(e.target);
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.01 });
    nodes.forEach(function (n) { io.observe(n); });

    setTimeout(function () {
      if (alive) return;
      io.disconnect();
      nodes.forEach(show);
    }, 1400);
  }

  function init() { reveal(); }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
