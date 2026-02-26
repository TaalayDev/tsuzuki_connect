/**
 * TSUZUKI CONNECT - Save Manager
 * Handles save/load functionality with localStorage
 */

export class SaveManager {
    constructor() {
        this.storagePrefix = 'tsuzuki_';
    }
    
    /**
     * Check if any save data exists
     */
    hasSaveData() {
        const autoSave = localStorage.getItem(this.storagePrefix + 'auto');
        return autoSave !== null;
    }
    
    /**
     * Save game to a slot
     */
    saveGame(slotId, gameState) {
        try {
            const key = this.storagePrefix + slotId;
            const data = JSON.stringify(gameState);
            localStorage.setItem(key, data);
            console.log(`💾 Game saved to ${slotId}`);
            return true;
        } catch (e) {
            console.error('Failed to save game:', e);
            return false;
        }
    }
    
    /**
     * Load game from a slot
     */
    loadGame(slotId) {
        try {
            const key = this.storagePrefix + slotId;
            const data = localStorage.getItem(key);
            if (data) {
                return JSON.parse(data);
            }
            return null;
        } catch (e) {
            console.error('Failed to load game:', e);
            return null;
        }
    }
    
    /**
     * Auto-save current state
     */
    autoSave(gameState) {
        return this.saveGame('auto', gameState);
    }
    
    /**
     * Quick save
     */
    quickSave(gameState) {
        return this.saveGame('quick', gameState);
    }
    
    /**
     * Quick load
     */
    quickLoad() {
        return this.loadGame('quick');
    }
    
    /**
     * Delete a save slot
     */
    deleteSave(slotId) {
        try {
            const key = this.storagePrefix + slotId;
            localStorage.removeItem(key);
            console.log(`🗑️ Save ${slotId} deleted`);
            return true;
        } catch (e) {
            console.error('Failed to delete save:', e);
            return false;
        }
    }
    
    /**
     * Get all save slots info
     */
    getAllSaves() {
        const saves = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith(this.storagePrefix)) {
                const slotId = key.replace(this.storagePrefix, '');
                saves[slotId] = this.loadGame(slotId);
            }
        }
        return saves;
    }
    
    /**
     * Save settings
     */
    saveSettings(settings) {
        try {
            localStorage.setItem(this.storagePrefix + 'settings', JSON.stringify(settings));
            return true;
        } catch (e) {
            console.error('Failed to save settings:', e);
            return false;
        }
    }
    
    /**
     * Load settings
     */
    loadSettings() {
        try {
            const data = localStorage.getItem(this.storagePrefix + 'settings');
            return data ? JSON.parse(data) : null;
        } catch (e) {
            console.error('Failed to load settings:', e);
            return null;
        }
    }
    
    /**
     * Clear all game data
     */
    clearAllData() {
        const keys = [];
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith(this.storagePrefix)) {
                keys.push(key);
            }
        }
        keys.forEach(key => localStorage.removeItem(key));
        console.log('🗑️ All save data cleared');
    }
    
    /**
     * Export save data as JSON
     */
    exportSaveData() {
        const data = this.getAllSaves();
        data.settings = this.loadSettings();
        return JSON.stringify(data, null, 2);
    }
    
    /**
     * Import save data from JSON
     */
    importSaveData(jsonString) {
        try {
            const data = JSON.parse(jsonString);
            
            for (const [slotId, saveData] of Object.entries(data)) {
                if (slotId === 'settings') {
                    this.saveSettings(saveData);
                } else {
                    this.saveGame(slotId, saveData);
                }
            }
            
            return true;
        } catch (e) {
            console.error('Failed to import save data:', e);
            return false;
        }
    }
}
