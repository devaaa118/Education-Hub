package com.edu.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class TranslationResult {

    private final List<String> texts;
    private final boolean fallback;
    private final String errorMessage;

    private TranslationResult(List<String> texts, boolean fallback, String errorMessage) {
        this.texts = texts;
        this.fallback = fallback;
        this.errorMessage = errorMessage;
    }

    public static TranslationResult success(List<String> translatedTexts) {
        List<String> safeList = translatedTexts == null ? Collections.emptyList() : Collections.unmodifiableList(new ArrayList<>(translatedTexts));
        return new TranslationResult(safeList, false, null);
    }

    public static TranslationResult fallback(List<String> originalTexts, String errorMessage) {
        List<String> safeList = originalTexts == null ? Collections.emptyList() : Collections.unmodifiableList(new ArrayList<>(originalTexts));
        return new TranslationResult(safeList, true, errorMessage);
    }

    public List<String> getTexts() {
        return texts;
    }

    public boolean isFallback() {
        return fallback;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}
