import Foundation

public enum RequestError: Error
{
    case decodeJSONFailed
    case decoding(Error)
    case encodeJSONFailed
    case encoding(Error)
    case httpStatus(Int)
    case invalidEndpointDefinition(Resource, URL)
    case invalidURL
    case malformedAuthenticationCode(String)
    case noDataReturned
    case parsing(Error)
    case timeout
    case unexpected
    case urlLoading(Error)

    var localizedDescription: String
    {
        switch self {
        case .malformedAuthenticationCode(let code):
            return String(format: i18n.requestErrorMalformedAuthenticationCode, code)
        case .noDataReturned:
            return i18n.requestErrorNoDataReturned
        case let .httpStatus(code):
            return String(format: "%@ %d", i18n.requestErrorHttpStatus, code)
        case let .urlLoading(e):
            return String(format: "%@ %@", i18n.requestErrorUrlLoading, e.localizedDescription)
        case .unexpected:
            return i18n.requestErrorUnexpected
        case let .parsing(error):
            return String(format: "%@ %@", i18n.requestErrorParsing, "\(error)")
        case let .invalidEndpointDefinition(res, url):
            return String(format: "%@ %@ %@",
                          i18n.requestErrorInvalidEndpointDefinition,
                          String(describing: res),
                          String(describing: url))
        case let .encoding(error):
            return String(format: "%@ %@", i18n.requestErrorEncoding, "\(error)")
        case let .decoding(error):
            return String(format: "%@ %@", i18n.requestErrorDecoding, "\(error)")
        case .decodeJSONFailed:
            return String(format: i18n.requestErrorParsing)
        case .encodeJSONFailed:
            return i18n.requestErrorEncodeJSONFailed
        case .invalidURL:
            return i18n.requestErrorInvalidURL
        case .timeout:
            return i18n.timeout
        }
    }
    
    init?(httpStatus: Int)
    {
        switch httpStatus {
        case 400...599: self = RequestError.httpStatus(httpStatus)
        default: return nil
        }
    }
}
