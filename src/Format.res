// Format module - Generate MODS and Dublin Core XML from Zotero items

let modsNS = "http://www.loc.gov/mods/v3"
let dcNS = "http://purl.org/dc/elements/1.1/"

// XML generation helpers
let createXMLDocument = (rootElement: string): Dom.document => {
  let parser = %raw(`new DOMParser()`)
  let xmlDecl = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  parser->%raw(`function(p) { return p.parseFromString }`)(`${xmlDecl}${rootElement}`, "text/xml")
}

let createElement = (doc: Dom.document, namespace: string, tagName: string): Dom.element => {
  doc->%raw(`function(d, ns, tag) { return d.createElementNS(ns, tag) }`)
}

let createTextNode = (doc: Dom.document, text: string): Dom.node => {
  doc->%raw(`function(d, t) { return d.createTextNode(t) }`)
}

let appendChild = (parent: Dom.element, child: Dom.node): unit => {
  parent->%raw(`function(p, c) { p.appendChild(c) }`)
}

let setAttribute = (element: Dom.element, name: string, value: string): unit => {
  element->%raw(`function(e, n, v) { e.setAttribute(n, v) }`)
}

let serializeToString = (doc: Dom.document): string => {
  let serializer = %raw(`new XMLSerializer()`)
  serializer->%raw(`function(s, d) { return s.serializeToString(d) }`)
}

let mapProperty = (
  doc: Dom.document,
  ns: string,
  parent: Dom.element,
  elementName: string,
  property: option<string>,
): unit => {
  switch property {
  | None => ()
  | Some(value) => {
      let element = createElement(doc, ns, elementName)
      let textNode = createTextNode(doc, value)
      appendChild(element, textNode->Obj.magic)
      appendChild(parent, element->Obj.magic)
    }
  }
}

// Generate MODS XML for an item
let generateMODS = (item: Zotero.item): string => {
  let modsEl = `<mods xmlns="${modsNS}" xmlns:mods="${modsNS}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="${modsNS} http://www.loc.gov/standards/mods/mods.xsd" />`

  let doc = createXMLDocument(modsEl)
  let mods = doc->%raw(`function(d) { return d.documentElement }`)

  // Add title
  let title = item.getDisplayTitle()
  if title != "" {
    let titleInfo = createElement(doc, modsNS, "titleInfo")
    mapProperty(doc, modsNS, titleInfo, "title", Some(title))
    appendChild(mods, titleInfo->Obj.magic)
  }

  // Add creators
  let creators = item.getCreators()
  for i in 0 to creators->Array.length - 1 {
    let creator = creators[i]
    let fullName = switch creator.firstName {
    | Some(first) => `${first} ${creator.lastName}`
    | None => creator.lastName
    }

    let name = createElement(doc, modsNS, "name")
    setAttribute(name, "type", "personal")
    mapProperty(doc, modsNS, name, "namePart", Some(fullName))
    appendChild(mods, name->Obj.magic)
  }

  serializeToString(doc)
}

// Generate Dublin Core XML for an item
let generateDC = (item: Zotero.item): string => {
  let dcEl = `<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="${dcNS}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd" />`

  let doc = createXMLDocument(dcEl)
  let dc = doc->%raw(`function(d) { return d.documentElement }`)

  mapProperty(doc, dcNS, dc, "dc:identifier", Some(item.libraryKey))

  serializeToString(doc)
}
