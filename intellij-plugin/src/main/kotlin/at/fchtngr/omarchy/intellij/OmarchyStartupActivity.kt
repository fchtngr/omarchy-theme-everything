package at.fchtngr.omarchy.intellij

import com.intellij.openapi.diagnostic.thisLogger
import com.intellij.openapi.project.Project
import com.intellij.openapi.startup.ProjectActivity
import java.nio.file.Files

class OmarchyStartupActivity : ProjectActivity {
    override suspend fun execute(project: Project) {
        val logger = thisLogger()
        val themeExists = Files.exists(OmarchyPaths.themeJson)
        logger.info("Omarchy plugin startup: watcher path=${OmarchyPaths.baseDir}, themeExists=$themeExists")
        OmarchyNotifications.info(
            "Omarchy plugin loaded",
            "Watcher started for ${OmarchyPaths.baseDir}"
        )
        OmarchyThemeWatcher.ensureStarted()
        OmarchyThemeRefresher.refresh("startup")
    }
}
