# flutter_izipay

[![Pub Version](https://img.shields.io/pub/v/flutter_izipay)](https://pub.dev/packages/flutter_izipay)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter wrapper for the official IziPay Android and iOS SDKs, enabling seamless integration of direct payment functionalities into Flutter applications.


## 🚀 Features available

- **Direct Payment Support**: Currently, the `payDirectly` method is the only available feature in this version.

## 📋 Requirements

### Flutter
- Flutter SDK: >=3.0.0

### Platforms
- **Android**: minSdkVersion 23
- **iOS**: >=16.0


## 📦 Installation

Add this library to your `pubspec.yaml` file:

```yaml
dependencies:
  izipay_flutter_sdk: any
```

### Android
> Para usar Izipay en android es necesario configurar el hilt

1. En **/android/build.gradle** agregar al inicio del archivo

```groovy
plugins {
    id 'com.google.dagger.hilt.android' version '2.44' apply false
}
```

2. En **/android/app/build.gradle** agregar a los plugins

```groovy
plugins {
    id 'kotlin-kapt'
    id 'com.google.dagger.hilt.android'
}
```

3. En **/android/app/build.gradle** agregar las dependencias
```groovy
implementation "com.google.dagger:hilt-android:2.44"
kapt "com.google.dagger:hilt-compiler:2.44"
```

4. En **/android/app/build.gradle** agregar las siguientes configuraciones para android
```groovy
android {
    buildFeatures {
        viewBinding true
    }

    hilt {
        enableAggregatingTask = false
        enableExperimentalClasspathAggregation = true
    }    
}
```

5. Crear una aplicación en kotlin

```kotlin
import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class ExampleApplication : Application()
```

6. Hacer referencia de la aplicación en el manifest

```xml
<application
        android:name=".ExampleApplication"
/>
```

## 📚 Additional Resources
For more information about the underlying SDKs and the complete payment platform, visit the official [IziPay Documentation](https://developers.izipay.pe).

