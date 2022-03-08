import Foundation
import RealmSwift

// MARK: - NewFeedModel

struct NewsFeedModel: BaseModel {
    var pagination: Pagination?
    var data: [FeedData]?
}

// MARK: - Datum
@objcMembers final class FeedData: Object, BaseModel {
    dynamic var author: String?
    dynamic var title, datumDescription: String?
    dynamic var url: String?
    dynamic var source: String?
    dynamic var image: String?
    dynamic var category: String?
    dynamic var language: String?
    dynamic var country: String?
    dynamic var publishedAt: Date?
    
    @objc dynamic var uuid : String = ""

      override public static func primaryKey() -> String? {
          return "uuid"
      }
    
    var imageURL: URL? {
        return URL(string: image ?? "")
    }
    
    public convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? ""
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.datumDescription = try container.decodeIfPresent(String.self, forKey: .datumDescription) ?? ""
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.publishedAt = try container.decodeIfPresent(Date.self, forKey: .publishedAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case author, title, uuid
        case datumDescription = "description"
        case url, source, image, category, language, country
        case publishedAt = "published_at"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    var limit, offset, count, total: Int?
}
