package com.edu.service;

import java.util.List;

/**
 * Legacy translation service. Backend translations have been removed in favor of
 * client-side Google Translate widget, so this stub simply echoes the original input.
 */
public final class TranslationService {

    private static final TranslationService INSTANCE = new TranslationService();

    private TranslationService() {
        // prevent external instantiation
    }

    public static TranslationService getInstance() {
        return INSTANCE;
    }

    public List<String> translateAll(List<String> values, String targetLanguage) {
        return values == null ? List.of() : List.copyOf(values);
    }
}
