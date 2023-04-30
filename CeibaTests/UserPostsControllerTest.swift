import XCTest
import CoreData
@testable import Ceiba

class UserPostsControllerTests: XCTestCase {
    
    var sut: UserPostsController!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "UserPostsController") as? UserPostsController
        sut.loadViewIfNeeded()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mockContext = appDelegate.persistentContainer.newBackgroundContext()
        sut.context = mockContext
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        mockContext = nil
    }
    
    func testGetUserPosts() {
        // Given
        let user = UserDTO(id: 1, name: "Test User", username: "testuser", email: "testuser@example.com", phone: "1234567890")
        sut.user = user
        
        let post1 = Post(context: mockContext)
        post1.userId = 1
        post1.id = 1
        post1.title = "Test Title 1"
        post1.body = "Test Body 1"
        
        let post2 = Post(context: mockContext)
        post2.userId = 1
        post2.id = 2
        post2.title = "Test Title 2"
        post2.body = "Test Body 2"
        
        try! mockContext.save()
        
        // When
        sut.getUserPosts()
        
        // Then
        XCTAssertEqual(sut.userPosts.count, 2)
    }
}
