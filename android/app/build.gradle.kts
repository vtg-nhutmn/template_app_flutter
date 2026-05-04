import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val stgKeyPropertiesFile = rootProject.file("key-stg.properties")
val stgKeyProperties = Properties()
if (stgKeyPropertiesFile.exists()) {
    stgKeyProperties.load(stgKeyPropertiesFile.inputStream())
}

val prodKeyPropertiesFile = rootProject.file("key-prod.properties")
val prodKeyProperties = Properties()
if (prodKeyPropertiesFile.exists()) {
    prodKeyProperties.load(prodKeyPropertiesFile.inputStream())
}

dependencies {
  implementation(platform("com.google.firebase:firebase-bom:34.12.0"))
  implementation("com.google.firebase:firebase-analytics")
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

android {
    namespace = "vn.vinhtan.app.demo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "vn.vinhtan.app.demo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("stg") {
            keyAlias = stgKeyProperties["keyAlias"] as String?
            keyPassword = stgKeyProperties["keyPassword"] as String?
            storeFile = stgKeyProperties["storeFile"]?.let { file(it) }
            storePassword = stgKeyProperties["storePassword"] as String?
        }
        create("prod") {
            keyAlias = prodKeyProperties["keyAlias"] as String?
            keyPassword = prodKeyProperties["keyPassword"] as String?
            storeFile = prodKeyProperties["storeFile"]?.let { file(it) }
            storePassword = prodKeyProperties["storePassword"] as String?
        }
    }

    flavorDimensions += "flavor-type"

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["appName"] = "Demo Dev"
        }
        create("stg") {
            dimension = "flavor-type"
            applicationIdSuffix = ".stg"
            versionNameSuffix = "-stg"
            manifestPlaceholders["appName"] = "Demo Stg"
            signingConfig = signingConfigs.getByName("stg")
        }
        create("prod") {
            dimension = "flavor-type"
            manifestPlaceholders["appName"] = "Demo"
            signingConfig = signingConfigs.getByName("prod")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
