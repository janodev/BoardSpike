import Foundation
import os

enum i18n
{
    static let add = i18n.localize("Add")
    static let addItem = i18n.localize("Add Item")
    
    static let requestErrorMalformedAuthenticationCode = "Malformed authentication code"
    static let requestErrorNoDataReturned = "No data returned"
    static let requestErrorHttpStatus = "HTTP error status"
    static let requestErrorUrlLoading = "Error loading URL"
    static let requestErrorUnexpected = "Unexpected error"
    static let requestErrorParsing = "Parsing error"
    static let requestErrorInvalidEndpointDefinition = "Invalid endpoint definition"
    static let requestErrorEncoding = "Encoding error"
    static let requestErrorDecoding = "Decoding error"
    static let requestErrorEncodeJSONFailed = "JSON encoding failed"
    static let requestErrorInvalidURL = "Invalid URL"
    static let timeout = "Timeout"
    
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
