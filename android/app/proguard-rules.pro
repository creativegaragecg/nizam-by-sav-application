# ── Flutter ──────────────────────────────────────────────
# 1. Keep the Background Isolate Entry Point (CRITICAL)
# This prevents R8 from removing functions marked with @pragma('vm:entry-point')
-keepattributes *Annotation*
-keep @interface dart.annotation.Binable
-keep @interface io.flutter.common.Pragma
-keep @interface androidx.annotation.Keep

-keep @dart.annotation.Binable class * { *; }
-keep @io.flutter.common.Pragma class * { *; }
-keep @androidx.annotation.Keep class * { *; }

-keepclassmembers class * {
    @dart.annotation.Binable *;
    @io.flutter.common.Pragma *;
    @androidx.annotation.Keep *;
}

# 2. Add the specific Firebase Messaging background service path
# Newer versions of the plugin use this path:
-keep class io.flutter.plugins.firebase.messaging.** { *; }

# 3. Specifically keep the Flutter Local Notifications classes
# Sometimes 'com.dexterous.**' isn't enough for the internal receivers
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.google.firebase.messaging.FirebaseMessagingService { *; }

-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# ── Firebase Core & Messaging ─────────────────────────────
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.messaging.** { *; }

# ── CRITICAL: Keep FCM background service entry points ────
-keep class com.google.firebase.messaging.FirebaseMessagingService { *; }
-keep class io.flutter.plugins.firebase.messaging.** { *; }
-keep class io.flutter.plugins.firebasemessaging.** { *; }

# ── Flutter Local Notifications ───────────────────────────
-keep class com.dexterous.** { *; }
-keep class androidx.core.app.** { *; }

# ── Keep Dart entry points (background isolate) ───────────
-keep @interface dart.annotation.DartName
-keepclassmembers class * {
    @dart.annotation.DartName *;
}

# ── Your Models ───────────────────────────────────────────
-keep class com.savvyions.** { *; }
-keepclassmembers class ** {
    factory *fromJson(***);
    *** toJson();
}

# ── Google Play Core (suppress missing class errors) ──────
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# ── Annotations & Signatures ──────────────────────────────
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ── Suppress warnings ─────────────────────────────────────
-dontwarn sun.misc.**
-dontwarn java.lang.invoke.**