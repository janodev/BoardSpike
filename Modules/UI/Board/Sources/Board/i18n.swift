import Foundation
import os

enum i18n
{
    static let add = i18n.localize("Add")
    static let addItem = i18n.localize("Add Item")

    static func localize(_ key: String) -> String
    {
        guard let bundle = Bundle(identifier: LocalizationBundle) else
        {
            log.error("> Missing bundle: \(LocalizationBundle)")
            return key
        }
        // swiftlint:disable:next nslocalizedstring_key
        return NSLocalizedString(key, tableName: LocalizationFilename, bundle: bundle, value: key, comment: "")
    }
}
