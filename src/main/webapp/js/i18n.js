(function () {
    const SUPPORTED_LANGS = ['en', 'ta'];
    const DEFAULT_LANG = 'en';
    const LANG_QUERY_PARAM = 'lang';
    const contextPath = (typeof window.APP_CONTEXT_PATH !== 'undefined') ? window.APP_CONTEXT_PATH : '';

    const getStoredLanguage = () => {
        try {
            const stored = localStorage.getItem('preferredLanguage');
            if (stored && SUPPORTED_LANGS.includes(stored)) {
                return stored;
            }
        } catch (err) {
            console.warn('Unable to read preferred language from storage', err);
        }
        return null;
    };

    const persistLanguage = (lang) => {
        try {
            localStorage.setItem('preferredLanguage', lang);
        } catch (err) {
            console.warn('Unable to persist preferred language', err);
        }
    };

    const resolveInitialLanguage = () => {
        const params = new URLSearchParams(window.location.search);
        const paramLang = params.get(LANG_QUERY_PARAM);
        if (paramLang && SUPPORTED_LANGS.includes(paramLang)) {
            persistLanguage(paramLang);
            return paramLang;
        }
        const stored = getStoredLanguage();
        if (stored) {
            return stored;
        }
        const navigatorLang = (navigator.language || navigator.userLanguage || '').slice(0, 2).toLowerCase();
        if (SUPPORTED_LANGS.includes(navigatorLang)) {
            return navigatorLang;
        }
        return DEFAULT_LANG;
    };

    const ensureUrlHasLang = (lang) => {
        const params = new URLSearchParams(window.location.search);
        if (params.get(LANG_QUERY_PARAM) !== lang) {
            params.set(LANG_QUERY_PARAM, lang);
            const newUrl = `${window.location.pathname}?${params.toString()}${window.location.hash || ''}`;
            window.history.replaceState({}, '', newUrl);
        }
    };

    const GOOGLE_TRANSLATE_MAP = {
        en: '',
        ta: 'ta'
    };
    const GOOGLE_TRANSLATE_REVERSE_MAP = {
        '': 'en',
        en: 'en',
        ta: 'ta'
    };
    let suppressLanguageChange = false;

    const dispatchComboChange = (combo) => {
        const event = document.createEvent('HTMLEvents');
        event.initEvent('change', true, true);
        combo.dispatchEvent(event);
    };

    const triggerGoogleTranslate = (lang, attempt = 0) => {
        window.__preferredLanguage = lang;
        const targetValue = GOOGLE_TRANSLATE_MAP[lang] !== undefined ? GOOGLE_TRANSLATE_MAP[lang] : '';
        const combo = document.querySelector('.language-switcher.goog-te-combo') || document.querySelector('.goog-te-combo');
        if (!combo) {
            if (attempt < 60) {
                setTimeout(() => triggerGoogleTranslate(lang, attempt + 1), 250);
            }
            return;
        }
        suppressLanguageChange = true;
        try {
            if (combo.value !== targetValue) {
                combo.value = targetValue;
            }
            try {
                dispatchComboChange(combo);
            } catch (err) {
                combo.dispatchEvent(new Event('change', { bubbles: true }));
            }
        } finally {
            setTimeout(() => {
                suppressLanguageChange = false;
            }, 150);
        }
    };

    window.applyGoogleTranslateLanguage = (lang) => {
        triggerGoogleTranslate(lang);
    };

    const parseOptions = (attrValue) => {
        if (!attrValue) return {};
        try {
            return JSON.parse(attrValue);
        } catch (err) {
            console.warn('Invalid data-i18n-options JSON', attrValue, err);
            return {};
        }
    };

    const collectDatasetOptions = (el) => {
        const options = {};
        if (!el || !el.dataset) return options;
        Object.keys(el.dataset).forEach((key) => {
            if (!key.startsWith('i18nParam')) return;
            const param = key.substring('i18nParam'.length);
            if (!param) return;
            const normalized = param.charAt(0).toLowerCase() + param.slice(1);
            options[normalized] = el.dataset[key];
        });
        return options;
    };

    const translateElement = (el) => {
        const key = el.getAttribute('data-i18n');
        if (!key) return;
        const optionsAttr = el.getAttribute('data-i18n-options');
        const options = Object.assign({}, collectDatasetOptions(el), parseOptions(optionsAttr));
        const value = i18next.t(key, options);
        el.innerHTML = value;
    };

    const translateAttribute = (el, attributeName, key) => {
        if (!attributeName) return;
        const optionsAttr = el.getAttribute('data-i18n-options');
        const options = Object.assign({}, collectDatasetOptions(el), parseOptions(optionsAttr));
        const attrKey = key || el.getAttribute(`data-i18n-${attributeName}`) || el.getAttribute('data-i18n');
        if (!attrKey) return;
        el.setAttribute(attributeName, i18next.t(attrKey, options));
    };

    const setupLanguageSwitcher = (select) => {
        if (!select) return;
        if (!select.classList.contains('language-switcher')) {
            select.classList.add('language-switcher');
        }
        if (!select.dataset.initialized) {
            select.addEventListener('change', (event) => {
                const rawValue = event.target.value;
                const lang = GOOGLE_TRANSLATE_REVERSE_MAP.hasOwnProperty(rawValue)
                    ? GOOGLE_TRANSLATE_REVERSE_MAP[rawValue]
                    : rawValue;
                if (!SUPPORTED_LANGS.includes(lang)) return;
                if (suppressLanguageChange && lang === (i18next.language || DEFAULT_LANG)) {
                    return;
                }
                persistLanguage(lang);
                ensureUrlHasLang(lang);
                if (i18next.language === lang) {
                    triggerGoogleTranslate(lang);
                    return;
                }
                i18next.changeLanguage(lang).then(() => {
                    triggerGoogleTranslate(lang);
                });
            });
            select.dataset.initialized = 'true';
        }
        const mappedValue = GOOGLE_TRANSLATE_MAP[i18next.language] !== undefined
            ? GOOGLE_TRANSLATE_MAP[i18next.language]
            : i18next.language;
        if (select.value !== mappedValue) {
            suppressLanguageChange = true;
            select.value = mappedValue;
            setTimeout(() => {
                suppressLanguageChange = false;
            }, 100);
        }
    };

    const updateTranslations = () => {
        document.documentElement.setAttribute('lang', i18next.language || DEFAULT_LANG);
        document.querySelectorAll('[data-i18n]').forEach(translateElement);
        document.querySelectorAll('[data-i18n-attr]').forEach((el) => {
            const attrs = el.getAttribute('data-i18n-attr');
            if (!attrs) return;
            attrs.split(',').map((attr) => attr.trim()).filter(Boolean).forEach((attr) => translateAttribute(el, attr));
        });
        document.querySelectorAll('[data-i18n-placeholder]').forEach((el) => {
            const key = el.getAttribute('data-i18n-placeholder');
            el.setAttribute('placeholder', i18next.t(key));
        });
        document.querySelectorAll('[data-i18n-value]').forEach((el) => {
            const key = el.getAttribute('data-i18n-value');
            el.value = i18next.t(key);
        });
        const titleEl = document.querySelector('title[data-i18n]');
        if (titleEl) {
            translateElement(titleEl);
            document.title = titleEl.textContent;
        }
        document.querySelectorAll('.language-switcher').forEach(setupLanguageSwitcher);
        document.querySelectorAll('form').forEach((form) => {
            if (form.dataset.langAugmented === 'true') {
                const hidden = form.querySelector(`input[name="${LANG_QUERY_PARAM}"]`);
                if (hidden) hidden.value = i18next.language;
                return;
            }
            const hiddenInput = document.createElement('input');
            hiddenInput.type = 'hidden';
            hiddenInput.name = LANG_QUERY_PARAM;
            hiddenInput.value = i18next.language;
            form.appendChild(hiddenInput);
            form.dataset.langAugmented = 'true';
        });
        triggerGoogleTranslate(i18next.language || DEFAULT_LANG);
    };

    const interceptAnchorNavigation = () => {
        document.addEventListener('click', (event) => {
            const anchor = event.target.closest('a');
            if (!anchor) return;
            if (anchor.dataset.keepLang === 'false') return;
            const href = anchor.getAttribute('href');
            if (!href || href.startsWith('#') || href.startsWith('javascript:')) return;
            try {
                const url = new URL(href, window.location.origin);
                if (url.origin !== window.location.origin) return;
                url.searchParams.set(LANG_QUERY_PARAM, i18next.language || DEFAULT_LANG);
                event.preventDefault();
                window.location.assign(url.pathname + url.search + url.hash);
            } catch (err) {
                console.warn('Unable to append lang param to link', err);
            }
        }, true);
    };

    document.addEventListener('DOMContentLoaded', () => {
        const lang = resolveInitialLanguage();
        persistLanguage(lang);
        ensureUrlHasLang(lang);
        window.__preferredLanguage = lang;
        interceptAnchorNavigation();
        i18next
            .use(i18nextHttpBackend)
            .use(i18nextBrowserLanguageDetector)
            .init({
                lng: lang,
                fallbackLng: DEFAULT_LANG,
                supportedLngs: SUPPORTED_LANGS,
                debug: false,
                backend: {
                    loadPath: `${contextPath}/i18n/{{lng}}.json`,
                    allowMultiLoading: false
                },
                interpolation: {
                    escapeValue: false
                }
            }, (err) => {
                if (err) {
                    console.error('i18next init failed', err);
                }
                updateTranslations();
                triggerGoogleTranslate(i18next.language || DEFAULT_LANG);
            });
        i18next.on('languageChanged', () => {
            updateTranslations();
        });
    });

    const reapplyPreferredLanguage = () => {
        const activeLang = i18next && i18next.language ? i18next.language : resolveInitialLanguage();
        triggerGoogleTranslate(activeLang || DEFAULT_LANG);
    };

    if (typeof window !== 'undefined') {
        window.addEventListener('googleTranslateReady', () => {
            reapplyPreferredLanguage();
        });
        window.addEventListener('languageSwitcherRendered', (event) => {
            const select = event && event.detail && event.detail.select;
            if (select) {
                setupLanguageSwitcher(select);
                updateTranslations();
            }
        });
        if (window.googleTranslateReady) {
            setTimeout(() => {
                reapplyPreferredLanguage();
            }, 0);
        }
    }
})();
