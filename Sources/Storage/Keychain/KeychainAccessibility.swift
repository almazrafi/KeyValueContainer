import Foundation

public enum KeychainAccessibility {

    /// The data in the keychain item cannot be accessed after a restart
    /// until the device has been unlocked once by the user.
    ///
    /// After the first unlock, the data remains accessible until the next restart.
    /// This is recommended for items that need to be accessed by background applications.
    /// Items with this attribute migrate to a new device when using encrypted backups.
    case afterFirstUnlock

    /// The data in the keychain item cannot be accessed after a restart
    /// until the device has been unlocked once by the user.
    ///
    /// After the first unlock, the data remains accessible until the next restart.
    /// This is recommended for items that need to be accessed by background applications.
    /// Items with this attribute do not migrate to a new device.
    /// Thus, after restoring from a backup of a different device, these items will not be present.
    case afterFirstUnlockThisDeviceOnly

    /// The data in the keychain can only be accessed when the device is unlocked.
    /// Only available if a passcode is set on the device.
    ///
    /// This is recommended for items that only need to be accessible while the application is in the foreground.
    /// Items with this attribute never migrate to a new device.
    /// After a backup is restored to a new device, these items are missing.
    /// No items can be stored in this class on devices without a passcode.
    /// Disabling the device passcode causes all items in this class to be deleted.
    case whenPasscodeSetThisDeviceOnly

    /// The data in the keychain item can be accessed only while the device is unlocked by the user.
    ///
    /// This is recommended for items that need to be accessible only while the application is in the foreground.
    /// Items with this attribute migrate to a new device when using encrypted backups.
    ///
    /// This is the default value for keychain items added without explicitly setting an accessibility constant.
    case whenUnlocked

    /// The data in the keychain item can be accessed only while the device is unlocked by the user.
    ///
    /// This is recommended for items that need to be accessible only while the application is in the foreground.
    /// Items with this attribute do not migrate to a new device.
    /// Thus, after restoring from a backup of a different device, these items will not be present.
    case whenUnlockedThisDeviceOnly
}
