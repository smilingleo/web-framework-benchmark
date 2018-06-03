extern crate actix;
extern crate actix_web;

extern crate bytes;
extern crate futures;
extern crate serde_json;
#[macro_use]
extern crate serde_derive;

use actix_web::{
    http, server, App, AsyncResponder, HttpMessage, HttpRequest, HttpResponse, Error
};

use futures::Future;

#[derive(Debug, Serialize, Deserialize)]
struct MyObj {
    name: String,
    number: i32,
}


fn extra_item(req: HttpRequest) -> Box<Future<Item = HttpResponse, Error = Error>> {
    req.json()
        .from_err()
        .and_then(|val: MyObj| {
            Ok(HttpResponse::Ok().json(val))
        })
        .responder()
}

fn main() {
    let sys = actix::System::new("json-example");

    server::new(||{
            App::new()
                .resource("/json-data", |r| {
                    r.method(http::Method::POST)
                        .a(extra_item);
                })
    })
    .workers(64)
    .bind("127.0.0.1:8080").unwrap()
    .start();

    println!("Started http server at: 127.0.0.1:8080");
    let _ = sys.run();
}
