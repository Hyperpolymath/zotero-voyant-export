# Zotero Voyant Export

Export your Zotero collections to Voyant.

[Voyant](http://voyant-tools.org/) is "a web-based text analysis and reading environment" that lets you visualize the content of a text corpus. 

[Zotero](https://www.zotero.org/) is a "a free, easy-to-use tool to help you collect, organize, cite, and share your research sources." 

This translator aims to help those with preexisting Zotero collections get a new view on their data via Voyant.

## Requirements

* [Zotero Standalone 5.0][zot] or higher; note that **the beta will irreversibly upgrade your database** (!), so take care to backup beforehand.
* a collection containing full texts (as PDFs, HTML snapshots, etc.)

## Installation

Download the latest [release][release] of the XPI (click "Save Link As..." if in Firefox). Then open Zotero Standalone and select the Tools menu -> Add-ons.
Click the gear icon in the upper right and select "Install Add-On From File..."; open the XPI file you just saved.

## Usage

Right-click on the collection you wish to analyze. Select "Export Collection to Voyant..." and choose a save location for the corpus as a zip file.

Upload the resulting zip to [voyant-tools.org](voyant-tools.org) (or to [your local Voyant server][local-voyant] -- 
For collections larger than a handful of documents, you'll probably want to host locally). You should then be able to see your corpus in the default Voyant view.

## Development

I have started with a code update to modern, dependable, and secure languages, as part of my rhodiumising of repositories work.
At the moment I have only just completed a sweep at a top level, and so there is more work to be done to get this to production.
Please be patient whilst I get round to that - I am not paid as part of this side to my work, rather offering skills to support Zotero's cause.

## Build

Run `just build` to create a new XPI.

Signing can be done with `just sign`, if you have the `JWT_ISSUER` and `JWT_SECRET` environment variables set. 
The `update.rdf` will be signed with [uhura](http://www.softlights.net/projects/mxtools/) 
NOTE: Make sure you have the private key file path as `UHURA_PEM_FILE` in your environment (scripts for major shells in scripts folder).

### Tests

Run the tests using Firefox Nightly, e.g.:

```
jpm test -b /Applications/Nightly.app/
```

[local-voyant]: http://docs.voyant-tools.org/resources/run-your-own/voyant-server/
[zot]: https://forums.zotero.org/discussion/59829/zotero-5.0-beta/
[release]: https://github.com/corajr/zotero-voyant-export/releases
[project]: https://github.com/corajr/zotero-voyant-export/projects/1

## LICENSE

This project is licensed under the MIT License. This is an OSI-approved license that removes all friction for adoption while protecting the core intellectual contributions of the MAA framework.
It is also dual-licensed under the Palimpsest License (v0.6). This is the preferred license for users, projects, and organisations who wish to formally commit to the foundational axiological principles of this framework.
See the LICENSE (Apache 2.0) and PALIMPSEST_LICENSE_v0.6.md files in the root of this repository.
