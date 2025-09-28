package com.edu.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


import com.edu.model.ClassInfo;

public final class ClassCatalogUtil {

        private static final List<ClassInfo> CLASS_LIST = new ArrayList<>();
        private static final Map<Integer, ClassInfo> CLASS_MAP = new LinkedHashMap<>();
        private static final Map<Integer, List<String>> SUBJECTS_BY_CLASS = new LinkedHashMap<>();

    static {
        register(1, "Class 1", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Environmental Science",
                "Moral Science",
                "Art & Craft"
        });
        register(2, "Class 2", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Environmental Science",
                "General Knowledge",
                "Art & Craft"
        });
        register(3, "Class 3", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Science",
                "Social Studies",
                "Computer Basics"
        });
        register(4, "Class 4", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Science",
                "Social Studies",
                "Computer Basics"
        });
        register(5, "Class 5", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Science",
                "Social Studies",
                "Computer Basics",
                "General Knowledge"
        });
        register(6, "Class 6", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Science",
                "Social Science",
                "Computer Science",
                "Hindi"
        });
        register(7, "Class 7", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Science",
                "Social Science",
                "Computer Science",
                "Hindi"
        });
        register(8, "Class 8", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Science",
                "Social Science",
                "Computer Science",
                "Hindi"
        });
        register(9, "Class 9", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Physics",
                "Chemistry",
                "Biology",
                "Social Science",
                "Computer Science"
        });
        register(10, "Class 10", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Physics",
                "Chemistry",
                "Biology",
                "Social Science",
                "Computer Science"
        });
        register(11, "Class 11", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Physics",
                "Chemistry",
                "Biology",
                "Computer Science",
                "Accountancy",
                "Business Studies",
                "Economics"
        });
        register(12, "Class 12", new String[] {
                "English",
                "Tamil",
                "Mathematics",
                "Physics",
                "Chemistry",
                "Biology",
                "Computer Science",
                "Accountancy",
                "Business Studies",
                "Economics"
        });
    }

    private ClassCatalogUtil() {
    }

        private static void register(int id, String name, String[] subjects) {
                ClassInfo info = new ClassInfo(id, name);
                CLASS_LIST.add(info);
                CLASS_MAP.put(id, info);
        List<String> subjectList = new ArrayList<>(Arrays.asList(subjects));
        SUBJECTS_BY_CLASS.put(id, Collections.unmodifiableList(subjectList));
    }

    public static List<ClassInfo> getAllClasses() {
        return new ArrayList<>(CLASS_LIST);
    }

    public static Map<Integer, List<String>> getSubjectsByClass() {
        Map<Integer, List<String>> copy = new LinkedHashMap<>();
        for (Map.Entry<Integer, List<String>> entry : SUBJECTS_BY_CLASS.entrySet()) {
            copy.put(entry.getKey(), entry.getValue());
        }
        return copy;
    }

        public static ClassInfo getClassById(int id) {
                return CLASS_MAP.get(id);
        }

        public static String getClassName(int id) {
                ClassInfo info = CLASS_MAP.get(id);
                return info != null ? info.getName() : "Class " + id;
        }

        public static boolean isValidClass(int id) {
                return CLASS_MAP.containsKey(id);
        }
}
