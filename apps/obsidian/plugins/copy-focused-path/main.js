const { Plugin, Notice, FileView } = require("obsidian");

module.exports = class CopyFocusedPathPlugin extends Plugin {
  onload() {
    // Path of the file/folder last clicked in the file explorer (vault-relative).
    // Cleared by any click outside the explorer so a stale folder is never
    // preferred over the active note.
    this.explorerPath = null;

    this.registerDomEvent(
      document,
      "mousedown",
      (evt) => {
        const title = evt.target.closest(".nav-file-title, .nav-folder-title");
        if (title && title.closest(".nav-files-container")) {
          this.explorerPath = title.getAttribute("data-path");
        } else if (!evt.target.closest(".nav-files-container")) {
          this.explorerPath = null;
        }
      },
      true
    );

    this.addCommand({
      id: "copy-full-path",
      name: "Copy full path of clicked file or folder",
      callback: async () => {
        let target = null;
        if (this.explorerPath) {
          target = this.app.vault.getAbstractFileByPath(this.explorerPath);
        }
        if (!target) {
          const view = this.app.workspace.getActiveViewOfType(FileView);
          target = view ? view.file : null;
        }
        if (!target) {
          new Notice("No file or folder to copy.");
          return;
        }
        const fullPath = this.app.vault.adapter.getFullRealPath(target.path);
        await navigator.clipboard.writeText(fullPath);
        new Notice("Copied: " + fullPath);
      },
    });
  }
};
