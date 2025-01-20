# flutter_izipay_example

## flutter_izipay

para importar flutter_izipay en android es necesario configurar el hilt

- importar hilt
implementation "com.google.dagger:hilt-android:2.44"
kapt "com.google.dagger:hilt-compiler:2.44"

- usarlo de plugin
id 'kotlin-kapt'
id 'com.google.dagger.hilt.android'

id 'com.google.dagger.hilt.android' version '2.44' apply false

- crear una clase application

@HiltAndroidApp
class ExampleApplication : Application()

- agregar la referencia en el manifest