import Cocoa
import Foundation

typealias CGWindow = [CFString: Any]

extension CGWindow {
    static func windows(_ option: CGWindowListOption) -> [CGWindow] {
        return CGWindowListCopyWindowInfo([.excludeDesktopElements, option], kCGNullWindowID) as! [CGWindow]
    }

    // workaround: filtering this criteria seems to remove non-windows UI elements
    func isNotMenubarOrOthers() -> Bool {
        return layer() == 0
    }

    // workaround: some apps like chrome use a window to implement the search popover
    func isReasonablyBig() -> Bool {
        let windowBounds = CGRect(dictionaryRepresentation: bounds()!)!
        return windowBounds.width > Preferences.minimumWindowSize && windowBounds.height > Preferences.minimumWindowSize
    }

    func id() -> CGWindowID? {
        return value(kCGWindowNumber, CGWindowID.self)
    }

    func layer() -> Int? {
        return value(kCGWindowLayer, Int.self)
    }

    func bounds() -> CFDictionary? {
        return value(kCGWindowBounds, CFDictionary.self)
    }

    func ownerPID() -> pid_t? {
        return value(kCGWindowOwnerPID, pid_t.self)
    }

    func ownerName() -> String? {
        return value(kCGWindowOwnerName, String.self)
    }

    func title() -> String? {
        return value(kCGWindowName, String.self)
    }

    private func value<T>(_ key: CFString, _ type: T.Type) -> T? {
        return self[key] as? T
    }
}