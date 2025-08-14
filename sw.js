self.addEventListener('install', e => {
  self.skipWaiting();
  e.waitUntil(caches.open('car-specs-ultra-v1').then(c => c.addAll(['./','./index.html','./manifest.webmanifest'])));
});
self.addEventListener('activate', e => { self.clients.claim(); });
self.addEventListener('fetch', e => {
  e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
});
