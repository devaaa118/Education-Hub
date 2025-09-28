package com.edu.model;

public class ResourceStat {
    private final String label;
    private final long count;

    public ResourceStat(String label, long count) {
        this.label = label;
        this.count = count;
    }

    public String getLabel() {
        return label;
    }

    public long getCount() {
        return count;
    }
}
