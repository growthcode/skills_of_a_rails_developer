# RESTful Notes

### (The RESTful Cookbook)[http://restcookbook.com/Basics/caching/] for great RESTful info. Better than below...

-------------

- One of the main differences between RESTful and other server-client communications services is that any session state in a RESTful setup is held in the client, the server is stateless. This requires the client to provide all information necessary to make the request.




- Services
  - HTTP
  - HTTPS

- Media Used
  - HTML
  - JSON
  - XML

- HTTP oriented around VERBS and RESOURCES
  - Verbs, 2 Main
      - GET
          - The GET method requests a representation of the specified resource. Requests using GET should only retrieve data and should have no other effect. (This is also true of some other HTTP methods.) The W3C has published guidance principles on this distinction, saying, "Web application design should be informed by the above principles, but also by the relevant limitations." See safe methods below.
      - POST
          - The POST method requests that the server accept the entity enclosed in the request as a new subordinate of the web resource identified by the URI. The data POSTed might be, for example, an annotation for existing resources; a message for a bulletin board, newsgroup, mailing list, or comment thread; a block of data that is the result of submitting a web form to a data-handling process; or an item to add to a database.
    - Verbs, Others defined in HTTP standard:
        - PUT
            - The PUT method requests that the enclosed entity be stored under the supplied URI. If the URI refers to an already existing resource, it is modified; if the URI does not point to an existing resource, then the server can create the resource with that URI.
        - DELETE
            - The DELETE method deletes the specified resource.
        - PATCH
            - The PATCH method applies partial modifications to a resource.
        - HEAD
            - The HEAD method asks for a response identical to that of a GET request, but without the response body. This is useful for retrieving meta-information written in response headers, without having to transport the entire content.
        - TRACE
            - The TRACE method echoes the received request so that a client can see what (if any) changes or additions have been made by intermediate servers.
        - OPTIONS
            - The OPTIONS method returns the HTTP methods that the server supports for the specified URL. This can be used to check the functionality of a web server by requesting '*' instead of a specific resource.
        - CONNECT
            - The CONNECT method converts the request connection to a transparent TCP/IP tunnel, usually to facilitate SSL-encrypted communication (HTTPS) through an unencrypted HTTP proxy.

- REST constraints
    - Client-server
        - A uniform interface separates clients from servers.
        - This separation of concerns means that, for example, clients are not concerned with data storage, which remains internal to each server, so that the portability of client code is improved.
        - Servers are not concerned with the user interface or user state, so that servers can be simpler and more scalable.
        - Servers and clients may also be replaced and developed independently, as long as the interface between them is not altered.
    - Stateless
        - The client–server communication is further constrained by no client context being stored on the server between requests.
        - Each request from any client contains all the information necessary to service the request, **and session state is held in the client**.
        - The session state can be transferred by the server to another service such as a database to maintain a persistent state for a period and allow authentication.
        - The client begins sending requests when it is ready to make the transition to a new state.
        - While one or more requests are outstanding, the client is considered to be in transition.
        - The representation of each application state contains links that may be used the next time the client chooses to initiate a new state-transition.

    - Cacheable
        - As on the World Wide Web, clients and intermediaries can cache responses.
        - Responses must therefore, implicitly or explicitly, define themselves as cacheable, or not, to prevent clients from reusing stale or inappropriate data in response to further requests.
        - Well-managed caching partially or completely eliminates some client–server interactions, further improving scalability and performance.

    - Layered system
        - A client cannot ordinarily tell whether it is connected directly to the end server, or to an intermediary along the way.
        - Intermediary servers may improve system scalability by enabling load balancing and by providing shared caches.
        - They may also enforce security policies.

    - Code on demand (optional)
        - Servers can temporarily extend or customize the functionality of a client by the transfer of executable code.
        - Examples of this may include compiled components such as Java applets and client-side scripts such as JavaScript.
        - "Code on demand" is the only optional constraint of the REST architecture.

    - Uniform interface
        - The uniform interface constraint is fundamental to the design of any REST service.
        - The uniform interface simplifies and decouples the architecture, which enables each part to evolve independently.
        - The four constraints for this uniform interface are:
            1. Identification of resources
                - Individual resources are identified in requests, for example using URIs in web-based REST systems.
                - The resources themselves are conceptually separate from the representations that are returned to the client.
                    - For example, the server may send data from its database as HTML, XML or JSON, none of which are the server's internal representation.
            1. Manipulation of resources through these representations
                - When a client holds a representation of a resource, including any metadata attached, it has enough information to modify or delete the resource.
            1. Self-descriptive messages
                - Each message includes enough information to describe how to process the message.
                - For example, which parser to invoke may be specified by an Internet media type (previously known as a MIME type). Responses also explicitly indicate their cacheability.
            1. Hypermedia as the engine of application state (HATEOAS)
                - Clients make state transitions only through actions that are dynamically identified within hypermedia by the server (e.g., by hyperlinks within hypertext).
                - What actions are possible vary as the state of the resource varies.
                - Except for simple fixed entry points to the application, a client does not assume that any particular action is available for any particular resources beyond those described in representations previously received from the server.


- RESTful APIs
    - APIs that adhere to the REST architectual constrains
    - Example:
        - base URI, such as:
        ` http://example.com/resources/ `
        - an Internet media type for the data
            - JSON
            - XML
            - ATOM
            - ect
        - standard HTTP methods
        ` GET `, ` PUT `, ` POST `, or ` DELETE `
        - hypertext links to reference state
        - hypertext links to reference-related resources




- Request => Resource Reached => Response
    - URLs
    - Server provides resources.
        - HTML files
        - Performs other functions on behalf of the client
    - Stuff that happens at the end point of an API call
    - Browsers Cache resources and reuse them when possible.
