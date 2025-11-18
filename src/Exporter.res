// Exporter module - Handle collection export to Voyant format

// File system helpers
let getTmpDir = (): {..} => {
  %raw(`
    (function() {
      const {FileUtils} = ChromeUtils.importESModule("resource://gre/modules/FileUtils.sys.mjs");
      const tmpDir = FileUtils.getFile("TmpD", ["collection"]);
      tmpDir.createUnique(0x01, 0o755); // DIRECTORY_TYPE = 0x01
      return tmpDir;
    })()
  `)
}

let mkdir = (startDir: {..}, dirName: string): {..} => {
  %raw(`
    (function(dir, name) {
      const newDir = dir.clone();
      newDir.append(name);
      newDir.create(0x01, 0o755); // DIRECTORY_TYPE = 0x01
      return newDir;
    })
  `)(startDir, dirName)
}

let fileInDir = (startDir: {..}, fileName: string): {..} => {
  %raw(`
    (function(dir, name) {
      const newFile = dir.clone();
      newFile.append(name);
      return newFile;
    })
  `)(startDir, fileName)
}

let copyFileTo = (sourceFile: {..}, targetDir: {..}, newName: string): unit => {
  %raw(`
    (function(src, dir, name) {
      src.copyTo(dir, name);
    })
  `)(sourceFile, targetDir, newName)
}

// Process a single item
let processItem = async (item: Zotero.item, dataDir: {..}): unit => {
  Zotero.debug(`Processing item ${Belt.Int.toString(item.id)}`)

  try {
    let attResult = await item.getBestAttachment()

    switch attResult->Js.Nullable.toOption {
    | None => Zotero.debug(`No attachment for item ${Belt.Int.toString(item.id)}`)
    | Some(att) => {
        let pathResult = await att.getFilePathAsync()

        switch pathResult->Js.Nullable.toOption {
        | None => Zotero.debug(`No file path for attachment on item ${Belt.Int.toString(item.id)}`)
        | Some(attPath) => {
            let attFile = Zotero.File.pathToFile(attPath)
            let itemID = Belt.Int.toString(item.id)

            Zotero.debug(`Saving item ${itemID}`)

            let itemOutDir = mkdir(dataDir, itemID)

            // Generate metadata
            let mods = Format.generateMODS(item)
            let dc = Format.generateDC(item)

            let modsFile = fileInDir(itemOutDir, "MODS.bin")
            let dcFile = fileInDir(itemOutDir, "DC.xml")

            Zotero.File.putContents(modsFile, mods)
            Zotero.File.putContents(dcFile, dc)

            // Copy attachment
            copyFileTo(attFile, itemOutDir, "CWRC.bin")
          }
        }
      }
    }
  } catch {
  | exn => Zotero.debug(`Error processing item ${Belt.Int.toString(item.id)}: ${exn->Obj.magic}`)
  }
}

// Export collection to Voyant format
let doExport = async (): unit => {
  Zotero.debug("[Voyant Export] Starting export")

  switch Zotero.getZoteroPane() {
  | None => Zotero.debug("[Voyant Export] Could not get Zotero pane")
  | Some(pane) => {
      let collectionResult = pane.getSelectedCollection()

      switch collectionResult->Js.Nullable.toOption {
      | None => Zotero.debug("[Voyant Export] No collection selected")
      | Some(collection) => {
          let name = collection.name
          let items = collection.getChildItems()

          Zotero.debug(
            `[Voyant Export] Collection: ${name}, ${Belt.Int.toString(items->Array.length)} items`,
          )

          // Show file picker
          let outFile = UI.showFilePicker(name)

          switch outFile->Js.Nullable.toOption {
          | None => Zotero.debug("[Voyant Export] Export cancelled")
          | Some(file) => {
              let outDir = getTmpDir()
              Zotero.debug(`[Voyant Export] Using tmp dir: ${outDir->Obj.magic}`)

              // Create bagit.txt
              let bagitFile = fileInDir(outDir, "bagit.txt")
              Zotero.File.putContents(bagitFile, "")

              // Create data directory
              let dataDir = mkdir(outDir, "data")

              // Process all items
              for i in 0 to items->Array.length - 1 {
                await processItem(items[i], dataDir)
              }

              // Zip the directory
              let outDirPath = %raw(`outDir.path`)
              let outFilePath = %raw(`file.path`)
              await Zotero.File.zipDirectory(outDirPath, outFilePath)

              Zotero.debug(`[Voyant Export] Export complete: ${outFilePath}`)
            }
          }
        }
      }
    }
  }
}
