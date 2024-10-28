import Foundation
import CoreData

extension WellnessTip {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WellnessTip> {
        return NSFetchRequest<WellnessTip>(entityName: "WellnessTip")
    }

    @NSManaged public var name: String?
}

extension WellnessTip: Identifiable {}
