import Fluent
import Vapor
import WebSocketKit
import Leaf

func routes(_ app: Application) throws {
    app.post("authors") { req -> EventLoopFuture<Author> in
        let author = try req.content.decode(Author.self)
        return author.create(on: req.db).map { author }
    }
    
    app.get("authors") {req -> EventLoopFuture<[Author]> in
        Author.query(on: req.db).all()
    }
    
    app.post("books") { req -> EventLoopFuture<Book> in
        let book = try req.content.decode(Book.self)
        return book.create(on: req.db).map { book }
    }
    
    app.get("books") {req -> EventLoopFuture<[Book]> in
        Book.query(on: req.db).all()
    }
    
    app.get("books-with-authors") { req -> EventLoopFuture<[Book]> in
        return Book.query(on: req.db).with(\.$author).all()
    }

    app.webSocket("chat") { req, ws in
        ws.onText { ws, text in
            print("recieved message: \(text)")
            ws.send("Echo: \(text)")
        }
    }
    
    
//        app.get("swiftui") { req -> EventLoopFuture<View> in
//            return req.view.render("swiftui", ContentView())
//        
//    }
    try app.register(collection: TodoController())
    
}
