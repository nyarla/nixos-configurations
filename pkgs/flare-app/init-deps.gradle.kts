gradle.projectsEvaluated {
    rootProject.allprojects {
        tasks.register("downloadDeps") {
            doLast {
                configurations.filter { it.isCanBeResolved }.forEach { 
                    try { it.resolve() } catch (e: Exception) { println("Skip ${it.name}") }
                }
                buildscript.configurations.filter { it.isCanBeResolved }.forEach { 
                    try { it.resolve() } catch (e: Exception) { println("Skip buildscript ${it.name}") }
                }
            }
        }
    }
}
