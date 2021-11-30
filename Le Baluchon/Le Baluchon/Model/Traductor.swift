
import Foundation

enum Language {
    case english
    case french
}

//  Mapping JSON data from API response using Codable Protocol to parse it later  :
struct TranslationData: Codable {
    var data: TranslationDetails
}

struct TranslationDetails: Codable {
    var translations: [TranslatedText]
}

struct TranslatedText: Codable {
    var translatedText: String
}
