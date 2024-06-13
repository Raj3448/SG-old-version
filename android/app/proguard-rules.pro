#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-ignorewarnings

# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keepattributes *Annotation*
-keepattributes Exceptions
-optimizations !method/inlining/*
-keepattributes JavascriptInterface
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Gson (if Razorpay SDK uses Gson)
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# OkHttp and Retrofit (if Razorpay SDK uses them)
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep interface okhttp3.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Retrofit
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers class ** {
    @retrofit2.http.* <methods>;
}
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

# Keep classes annotated with @GlideModule (if Razorpay SDK uses Glide)
-keep class com.bumptech.glide.annotation.GlideModule { *; }
-keep @com.bumptech.glide.annotation.GlideModule class * { *; }
-keep public class * extends com.bumptech.glide.module.AppGlideModule { *; }