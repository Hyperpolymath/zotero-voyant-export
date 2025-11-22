const self = require("sdk/self");
const utils = require("./lib/utils");
const ui = require("./lib/ui");
const zotero = require("./lib/zotero");
const exporter = require("./lib/exporter");
const { setTimeout } = require("sdk/timers");

// Initialization configuration
const MAX_RETRIES = 5;
const INITIAL_RETRY_DELAY_MS = 1000;

let retries = 0;

/**
 * Main initialization function
 * Implements retry logic with exponential backoff for Zotero API access
 *
 * @param {Object} options - Add-on options
 * @param {Object} callbacks - Callback functions
 */
const main = (options, callbacks) => {
  try {
    const Zotero = zotero.getZotero();

    // Zotero not yet available, retry with exponential backoff
    if (!Zotero && retries < MAX_RETRIES) {
      const delay = Math.pow(2, retries) * INITIAL_RETRY_DELAY_MS;
      console.log(`Zotero not available, retrying in ${delay}ms (attempt ${retries + 1}/${MAX_RETRIES})`);
      setTimeout(main, delay, options, callbacks);
      retries += 1;
      return;
    }

    // Maximum retries exceeded
    if (!Zotero) {
      const error = `Failed to initialize: Zotero not available after ${MAX_RETRIES} retries`;
      console.error(error);
      throw new Error(error);
    }

    // Successful initialization
    const logger = new utils.Logger(Zotero);
    logger.info("zotero-voyant-export loaded successfully");
    logger.info(`Add-on version: ${self.version || 'unknown'}`);

    // Insert menu item
    try {
      ui.insertExportMenuItem(exporter.doExport);
      logger.info("Export menu item installed");
    } catch (error) {
      logger.error(`Failed to insert export menu item: ${error.message}`);
      throw error;
    }

    // Reset retry counter for next load
    retries = 0;

  } catch (error) {
    console.error(`Initialization error: ${error.message}`);
    throw error;
  }
};

/**
 * Cleanup function called when add-on is unloaded
 *
 * @param {string} reason - Reason for unloading (shutdown, disable, etc.)
 */
const onUnload = (reason) => {
  console.log(`zotero-voyant-export unloading: ${reason || 'unknown reason'}`);

  try {
    ui.removeExportMenuItem();
    console.log("Export menu item removed");
  } catch (error) {
    console.error(`Error during unload: ${error.message}`);
    // Don't throw during unload - just log the error
  }
};

exports.main = main;
exports.onUnload = onUnload;
