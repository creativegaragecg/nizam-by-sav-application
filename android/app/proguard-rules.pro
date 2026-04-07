# ── Flutter ──────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# ── Firebase ─────────────────────────────────────────────
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.messaging.** { *; }

# ── Flutter Local Notifications ───────────────────────────
-keep class com.dexterous.** { *; }

# ── Shared Preferences ───────────────────────────────────
-keep class androidx.preference.** { *; }

# ── Your Models (JSON parsing) ────────────────────────────
-keep class savvyions.** { *; }
-keepclassmembers class ** {
    factory *fromJson(***);
    *** toJson();
}

# ── Annotations & Signatures (needed for reflection) ─────
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ── Suppress warnings ─────────────────────────────────────
-dontwarn sun.misc.**
-dontwarn java.lang.invoke.**


# ── Google Play Core (missing classes fix) ────────────────
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**