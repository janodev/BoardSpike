import Foundation
import Networking

/// Parameter for the createColumn(newColumn:) call.
public struct NewColumnParams
{
    public let color: String
    public let name: String
    public let projectId: String
}

/// Parameter for the moveCard call.
public struct MoveCardParams: Codable
{
    public let cardId: Int
    public let positionAfterId: Int
    public let columnId: Int
    var jsonData: Data? {
        try? JSONEncoder().encode(self)
    }
}

public protocol HasTeamworkClient {
    var teamworkClient: TeamWorkClientProtocol? { get set }
}

public protocol TeamWorkClientProtocol
{
    /// Tasks of a project.
    func tasks(projectId: String, completion: @escaping ResultCallback<TasksResponse>)
    
    /// Projects.
    func projects(completion: @escaping ResultCallback<ProjectsResponse>)
    
    /// Columns of the project board.
    func columns(projectId: String, completion: @escaping ResultCallback<ColumnsResponse>)
    
    /// Cards in a column.
    func cards(columnId: String, completion: @escaping ResultCallback<CardsResponse>)
    
    /// Create a column.
    func createColumn(newColumn: NewColumnParams, completion: @escaping ResultCallback<CreateColumnResponse>)
    
    /// Move a card within the board.
    func moveCard(params: MoveCardParams, completion: @escaping ResultCallback<MoveCardResponse>)
}

public final class TeamWorkClient: TeamWorkClientProtocol
{
    private let apiClient: ApiClient
    private var authProvider: AuthorizationProviderProtocol

    public convenience init(authProvider: AuthorizationProviderProtocol)
    {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = authProvider.authorizationHeader
        config.httpAdditionalHeaders?["Accept"] = "application/json"
        let session = URLSession(configuration: config)
        
        // This code fails if the installation is not EU. We need the whole base URL.
        // Maybe it’s returned by the login?
        // swiftlint:disable:next force_unwrapping
        let baseURL = URL(string: "https://\(authProvider.apiEndPoint)/")!
        let apiClient = ApiClient(baseURL: baseURL, session: session)
        
        self.init(apiClient: apiClient, authProvider: authProvider)
    }
    
    public init(apiClient: ApiClient, authProvider: AuthorizationProviderProtocol) {
        self.apiClient = apiClient
        self.authProvider = authProvider
    }

    /// Returns the tasks for a particular column id
    // curl -s -H "Accept: application/json" -H "Authorization: BASIC `echo -n twp_I7FulSTjVhfQz78p9ov2XQj8y2Tc_eu | base64`" https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/boards/columns/{id}/cards.json | python -mjson.tool
    public func cards(columnId: String, completion: @escaping ResultCallback<CardsResponse>) {
        let resource = Resource(path: "boards/columns/\(columnId)/cards.json")
        apiClient.request(resource, completion)
    }
    
    // curl -s -H "Accept: application/json" -H "Authorization: BASIC `echo -n twp_I7FulSTjVhfQz78p9ov2XQj8y2Tc_eu | base64`" https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/projects/468919/tasks.json | python -mjson.tool
    public func tasks(projectId: String, completion: @escaping ResultCallback<TasksResponse>) {
        let resource = Resource(path: "/projects/\(projectId)/tasks.json")
        apiClient.request(resource, completion)
    }
    
    // curl -s -H "Accept: application/json" -H "Authorization: BASIC `echo -n twp_I7FulSTjVhfQz78p9ov2XQj8y2Tc_eu | base64`" https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/projects.json | python -mjson.tool
    public func projects(completion: @escaping ResultCallback<ProjectsResponse>) {
        apiClient.request("/projects.json", completion)
    }
    
    /// Returns the names of the board columns, their display order, people involved, plus other attributes.
    /// curl -s -H "Accept: application/json" -H "Authorization: BASIC `echo -n twp_I7FulSTjVhfQz78p9ov2XQj8y2Tc_eu | base64`" https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/projects/468919/boards/columns.json | python -mjson.tool
    public func columns(projectId: String, completion: @escaping ResultCallback<ColumnsResponse>) {
        let resource = Resource(path: "/projects/\(projectId)/boards/columns.json")
        apiClient.request(resource, completion)
    }

    // curl -vvv -s -X POST --data-binary @createColumn.json -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: BASIC `echo -n twp_I7FulSTjVhfQz78p9ov2XQj8y2Tc_eu | base64`" https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/projects/468919/boards/columns.json
    // When creating more than three on a free project: {"MESSAGE":"You've reached your column limit on this project","STATUS":"Error"}
    // createColumn.json --> { "color": "A new hope", "name": "#27AE60" }
    // Note: unlike other calls, this needs "Content-Type: application/json"
    // Possible colors: #27AE60, #99DF72, #1ABC9C, #6866D0, #8E44AD, #0AD2F5, #3498DB, #3D82DE, #C0392B, #E74C3C, #A94136, #660A00, #F39C12, #F1C40F, #34495E, #7F8C8D, #D35400, #B49255, #D870AD, #BDC3C7, #9B59B6
    public func createColumn(newColumn: NewColumnParams, completion: @escaping ResultCallback<CreateColumnResponse>) {
        let resource = Resource(
            path: "/projects/\(newColumn.projectId)/boards/columns.json",
            body: "{ \"color\": \"\(newColumn.color)\", \"name\": \"\(newColumn.name)\" }".data(using: .utf8),
            method: .POST,
            query: ["Content-Type": "application/json"]
        )
        apiClient.request(resource, completion)
    }
    
    // https://developer.teamwork.com/projects/api-v1/ref/boards/put-boards-columns-cards-id-move-json
    // test needed
    public func moveCard(params: MoveCardParams, completion: @escaping ResultCallback<MoveCardResponse>) {
        guard let json = params.jsonData else {
            completion(.failure(.encodeJSONFailed))
            return
        }
        let resource = Resource(
            path: "/api-v1/ref/boards/put-boards-columns-cards-id-move-json",
            body: json,
            method: .PUT,
            query: ["Content-Type": "application/json"]
        )
        apiClient.request(resource, completion)
    }
}
