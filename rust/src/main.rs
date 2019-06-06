extern crate actix;
extern crate actix_web;

extern crate serde_json;
#[macro_use]
extern crate serde_derive;

use actix_web::{
    web, App, HttpServer, HttpResponse
};

#[derive(Debug, Serialize, Deserialize)]
struct MyObj {
    name: String,
    number: i32,
}

fn main() {
    println!("Started http server at: 127.0.0.1:8080");

    HttpServer::new(|| {
        App::new()
            .data(web::JsonConfig::default().limit(4096))
            .service(web::resource("/json-data").route(web::post().to(|item: web::Json<MyObj>|{
                HttpResponse::Ok().json(item.0)
            })))
    })
    .bind("127.0.0.1:8080").unwrap()
    .run();
}
