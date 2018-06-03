package leo.me.resources;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import leo.me.api.Data;

@Path("/extractor")
@Produces(MediaType.APPLICATION_JSON)
public class DataResource {

    @POST
    public Data postData(Data data) {
        return data;
    }
}