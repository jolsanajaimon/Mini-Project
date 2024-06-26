# Keep the names of classes used by Flutter.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }

# Keep audio files
-keep class com.example.smartpark.R$raw { *; }
-keepclassmembers class com.example.smartpark.R$raw {
    public static <fields>;
}
