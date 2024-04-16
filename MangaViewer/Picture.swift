import Foundation


struct PictureUrl : Decodable {
    var full : String
    var small : String
    var thumb : String
}

struct Picture: Identifiable, Decodable {
    var id: String
    var alt_description: String?
    var urls: PictureUrl
    
}


// for collectionview
enum PicSection {
    case main
}

class PicModelObject: Hashable , Identifiable, Decodable {
    var id : String
    var alt_description: String?
    var urls: PictureUrl
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: PicModelObject, rhs: PicModelObject) -> Bool {
        return lhs.id == rhs.id
    }
}

