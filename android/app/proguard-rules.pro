# ==============================================================================
# ProGuard & R8 Optimization / Keep Rules for TalkTranslo
# ==============================================================================

# Flutter Core & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Google Play Core Deferred Components (Optional in Flutter engine)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-keep class io.flutter.plugins.** { *; }

# Google ML Kit Text Recognition (Camera & Image OCR)
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }
-keep class com.google.android.gms.vision.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

# Speech-to-Text (STT) Native Recognition
-keep class com.csdcorp.speech_to_text.** { *; }
-keep class android.speech.** { *; }
-dontwarn com.csdcorp.speech_to_text.**

# Flutter TTS (Text-to-Speech) Platform Audio Engine
-keep class com.tundralabs.fluttertts.** { *; }
-keep class android.speech.tts.** { *; }
-dontwarn com.tundralabs.fluttertts.**

# SQLite Database Persistence (sqflite)
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**

# Image Cropper (UCrop Activity & Utilities)
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

# Share Plus Platform Integration
-keep class dev.fluttercommunity.plus.share.** { *; }
-dontwarn dev.fluttercommunity.plus.share.**

# Retain Reflection Annotations, Signatures & Exceptions
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes EnclosingMethod
