# Keep `Companion` object fields of serializable classes.
# This avoids serializer lookup through `getDeclaredClasses` as done for named companion objects.
-if @kotlinx.serialization.Serializable class **
-keepclassmembers class <1> {
   static <1>$Companion Companion;
}

# Keep `serializer()` on companion objects (both default and named) of serializable classes.
-if @kotlinx.serialization.Serializable class ** {
   static **$* *;
}
-keepclassmembers class <2>$<3> {
   kotlinx.serialization.KSerializer serializer(...);
}

# keep webrtc classes
-keep class org.webrtc.** { *; }
-dontwarn org.chromium.build.BuildHooksAndroid

# keep ktor classes
-keep class io.ktor.** { *; }

-keep class com.hyphenate.** {*;}
-dontwarn  com.hyphenate.**

-keep class io.agora.**{*;}


# Keep Groovy classes
-keep class org.codehaus.groovy.** { *; }
-dontwarn org.codehaus.groovy.**

# Keep Apache Ivy classes
-keep class org.apache.ivy.** { *; }
-dontwarn org.apache.ivy.**

# Keep XStream classes
-keep class com.thoughtworks.xstream.** { *; }
-dontwarn com.thoughtworks.xstream.**

# Keep Java Beans classes
-keep class java.beans.** { *; }
-dontwarn java.beans.**
