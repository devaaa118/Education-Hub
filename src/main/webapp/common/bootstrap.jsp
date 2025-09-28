<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<style>
	.goog-te-banner-frame.skiptranslate,
	#goog-gt-tt {
		display: none !important;
	}
	body {
		top: 0 !important;
	}
	.language-switcher-host {
		display: inline-flex;
		align-items: center;
		min-height: 32px;
	}
	#google_translate_container {
		display: inline-flex;
		align-items: center;
	}
	.language-switcher-host .goog-te-gadget {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		font-family: inherit;
		font-size: 0.85rem;
		color: inherit;
	}
	.language-switcher-host .goog-te-gadget span:first-child {
		display: none;
	}
	.language-switcher-host .goog-te-gadget span {
		display: inline-flex;
		align-items: center;
		font-size: 0.7rem;
		color: rgba(30, 64, 175, 0.6);
	}
	.navbar .language-switcher-host .goog-te-gadget span {
		color: rgba(255, 255, 255, 0.75);
	}
	.language-switcher-host select.language-switcher {
		min-width: 140px;
		border-radius: 999px;
		padding: 0.35rem 0.75rem;
		font-weight: 600;
		border: 1px solid rgba(37, 99, 235, 0.25);
		color: inherit;
		background-color: rgba(255, 255, 255, 0.9);
	}
	.navbar .language-switcher-host select.language-switcher {
		border-color: rgba(255, 255, 255, 0.35);
		background-color: rgba(255, 255, 255, 0.12);
		color: #fff;
	}
	.language-switcher-host select.language-switcher:focus {
		outline: none;
		box-shadow: 0 0 0 0.1rem rgba(37, 99, 235, 0.25);
	}
	.navbar .language-switcher-host select.language-switcher:focus {
		box-shadow: 0 0 0 0.1rem rgba(255, 255, 255, 0.45);
	}
	.goog-te-gadget .goog-te-gadget-simple {
		border: none !important;
		background: transparent !important;
		padding: 0 !important;
	}
	.goog-logo-link {
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
		font-size: 0.65rem;
		color: inherit;
		text-decoration: none;
	}
</style>
<script type="text/javascript">
	(function() {
		const READY_EVENT = 'googleTranslateReady';
		const HOST_SELECTOR = '[data-google-translate-host]';
		const CONTAINER_ID = 'google_translate_container';
		const MAX_ATTEMPTS = 60;
		const FALLBACK_DELAY = 4000;
		let fallbackTimer = null;
		let fallbackRendered = false;

		function dispatchReady() {
			if (!window.googleTranslateReady) {
				window.googleTranslateReady = true;
				window.dispatchEvent(new Event(READY_EVENT));
			}
		}

		function ensureContainer() {
			if (fallbackRendered) return null;
			const host = document.querySelector(HOST_SELECTOR);
			if (!host) return null;
			let container = document.getElementById(CONTAINER_ID);
			if (!container) {
				container = document.createElement('div');
				container.id = CONTAINER_ID;
				host.appendChild(container);
			} else if (container.parentElement !== host) {
				host.appendChild(container);
			}
			return container;
		}

		function localizeOptions(select) {
			if (!select) return;
			for (let i = 0; i < select.options.length; i++) {
				const opt = select.options[i];
				if (opt.value === '') {
					opt.textContent = 'English';
				} else if (opt.value === 'ta') {
					opt.textContent = 'Tamil';
				}
			}
		}

		function handleSelect(select) {
			if (!select) return;
			localizeOptions(select);
			select.classList.add('language-switcher');
			select.id = 'language-select';
			window.dispatchEvent(new CustomEvent('languageSwitcherRendered', { detail: { select } }));
			dispatchReady();
		}

		function renderFallback() {
			if (fallbackRendered) return;
			const host = document.querySelector(HOST_SELECTOR);
			if (!host) return;
			host.innerHTML = '';
			const select = document.createElement('select');
			select.className = 'form-select form-select-sm language-switcher manual-language-switcher';
			select.id = 'language-select';
			select.innerHTML = `
				<option value="en" data-i18n="language.english">English</option>
				<option value="ta" data-i18n="language.tamil">Tamil</option>
			`;
			const preferred = window.__preferredLanguage || 'en';
			select.value = preferred;
			host.appendChild(select);
			fallbackRendered = true;
			window.dispatchEvent(new CustomEvent('languageSwitcherRendered', { detail: { select } }));
			dispatchReady();
		}

		function watchForSelect(attempt = 0) {
			if (fallbackRendered) return;
			const container = document.getElementById(CONTAINER_ID);
			const combo = container ? container.querySelector('select.goog-te-combo') : null;
			if (combo) {
				if (fallbackTimer) {
					clearTimeout(fallbackTimer);
					fallbackTimer = null;
				}
				handleSelect(combo);
				return;
			}
			if (attempt < MAX_ATTEMPTS) {
				setTimeout(() => watchForSelect(attempt + 1), 200);
			} else {
				renderFallback();
			}
		}

		window.googleTranslateElementInit = function () {
			const container = ensureContainer();
			if (!container || !(window.google && google.translate)) {
				renderFallback();
				return;
			}
			new google.translate.TranslateElement({
				pageLanguage: 'en',
				includedLanguages: 'ta',
				layout: google.translate.TranslateElement.InlineLayout.SIMPLE
			}, CONTAINER_ID);
			fallbackTimer = setTimeout(renderFallback, FALLBACK_DELAY);
			watchForSelect();
		};

		document.addEventListener('DOMContentLoaded', () => {
			ensureContainer();
		});
	})();
</script>
<script type="text/javascript" src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
