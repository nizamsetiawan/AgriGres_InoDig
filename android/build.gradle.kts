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
            compileSdk = 36
            defaultConfig {
                minSdk = 23
            }
        }
        // Add dependencies after configuration
        afterEvaluate {
            dependencies {
                add("implementation", "androidx.appcompat:appcompat:1.7.0")
                add("implementation", "androidx.core:core-ktx:1.15.0")
            }
        }
    }
}
