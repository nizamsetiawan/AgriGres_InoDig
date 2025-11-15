// import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Force all Android library modules (e.g., plugins) to a modern compileSdk
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            compileSdk = 35
            defaultConfig {
                minSdk = 23
            }
            // Fix for tflite plugin compatibility - add namespace if missing
            if (project.name == "tflite") {
                namespace = "sq.flutter.tflite"
            }
        }
        // Add dependencies after configuration
        afterEvaluate {
            dependencies {
                add("implementation", "androidx.appcompat:appcompat:1.7.0")
                add("implementation", "androidx.core:core-ktx:1.15.0")
            }
            // Disable resource verification for tflite plugin to fix lStar attribute issue
            if (project.name == "tflite") {
                tasks.matching { it.name.contains("verify") && it.name.contains("Resources") }.configureEach {
                    enabled = false
                }
            }
        }
    }
}
