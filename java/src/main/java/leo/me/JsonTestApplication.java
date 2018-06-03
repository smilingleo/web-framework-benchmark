package leo.me;

import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import leo.me.resources.DataResource;

public class JsonTestApplication extends Application<JsonTestConfiguration> {

    public static void main(final String[] args) throws Exception {
        new JsonTestApplication().run(args);
    }

    @Override
    public String getName() {
        return "JsonTest";
    }

    @Override
    public void initialize(final Bootstrap<JsonTestConfiguration> bootstrap) {
    }

    @Override
    public void run(final JsonTestConfiguration configuration,
                    final Environment environment) {
        DataResource resource = new DataResource();
        environment.jersey().register(resource);
    }

}
