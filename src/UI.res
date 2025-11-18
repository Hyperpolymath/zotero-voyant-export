// UI module - Handle menu items and file picker

// File picker
let showFilePicker = (name: string): Js.Nullable.t<{..}> => {
  %raw(`
    (function(collectionName) {
      const nsIFilePicker = Components.interfaces.nsIFilePicker;
      const fp = Components.classes["@mozilla.org/filepicker;1"]
        .createInstance(nsIFilePicker);

      fp.defaultString = collectionName + ".zip";
      fp.defaultExtension = "zip";
      fp.appendFilter("ZIP", "*.zip");

      const window = Services.wm.getMostRecentWindow("navigator:browser");
      fp.init(window, "Export to Voyant", nsIFilePicker.modeSave);

      const rv = fp.show();
      if (rv != nsIFilePicker.returnOK && rv != nsIFilePicker.returnReplace) {
        return null;
      }
      return fp.file;
    })
  `)(name)
}

// Menu item management
let getCollectionMenu = (): option<Dom.element> => {
  switch Zotero.getZoteroPane() {
  | None => None
  | Some(pane) => {
      let doc = pane.document
      let menu = %raw(`doc.getElementById("zotero-collectionmenu")`)
      menu->Js.Nullable.toOption
    }
  }
}

let insertExportMenuItem = (onclick: unit => unit): unit => {
  switch getCollectionMenu() {
  | None => Zotero.debug("[Voyant Export] Could not get collection menu")
  | Some(menu) => {
      // Check if already exists
      let existing = %raw(`menu.querySelector('#voyant-export')`)

      if existing->Js.Nullable.isNullable {
        let doc = %raw(`menu.ownerDocument`)
        let menuitem = %raw(`doc.createElement("menuitem")`)

        %raw(`menuitem.setAttribute('id', 'voyant-export')`)
        %raw(`menuitem.setAttribute('label', "Export Collection to Voyant...")`)
        %raw(`menuitem.onclick = onclick`)
        %raw(`menu.appendChild(menuitem)`)

        Zotero.debug("[Voyant Export] Menu item added")
      }
    }
  }
}

let removeExportMenuItem = (): unit => {
  switch getCollectionMenu() {
  | None => ()
  | Some(menu) => {
      let menuitem = %raw(`menu.querySelector('#voyant-export')`)

      switch menuitem->Js.Nullable.toOption {
      | None => ()
      | Some(item) => {
          %raw(`item.parentNode.removeChild(item)`)
          Zotero.debug("[Voyant Export] Menu item removed")
        }
      }
    }
  }
}
