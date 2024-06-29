import type { HotKeyPadCommand, HotKeyPadOptionsProps } from "./types";
export default class HotKeyPad {
    #private;
    instance: HTMLElement;
    currentIndex: number;
    constructor({ closeKey, placeholder, activationLetter }?: HotKeyPadOptionsProps);
    open(): void;
    close(): void;
    setCommands(commands: HotKeyPadCommand[]): void;
    get activationKey(): string;
}
//# sourceMappingURL=index.d.ts.map