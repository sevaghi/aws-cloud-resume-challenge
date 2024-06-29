/**
 * Create a new element with the given tag and props
 * @param tag The tag of the element
 * @param props The props of the element
 * @returns The created element
 */
export declare function createElement(tag: string, props?: {
    [key: string]: string;
} | string): HTMLElement;
/**
 * Create a new listener for the given element and event
 * @param element The element to listen to
 * @param event The event to listen for
 * @param callback The callback to execute
 */
export declare function createListener<T>(element: HTMLElement | Document | Window, event: keyof HTMLElementEventMap, callback: (event: T) => void): void;
/**
 * Extract the valid letter from the hotkey
 * @param hotkey The hotkey to extract the letter from
 * @returns The activation letter in uppercase
 * @example
 * extractHotkey("Control + D") // "D"
 * extractHotkey("control + shift + l") // "L"
 */
export declare function extractHotkeyLetter(hotkey: string): string;
/**
 * Validate the given hotkey
 * @param hotkey The hotkey to verify
 * @returns Whether the hotkey is valid or not
 */
export declare function isValidHotkey(hotkey: string): boolean;
//# sourceMappingURL=utils.d.ts.map