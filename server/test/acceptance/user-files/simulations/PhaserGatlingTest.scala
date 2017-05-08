import io.gatling.core.scenario.Simulation
import ch.qos.logback.classic.{Level, LoggerContext}
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import org.slf4j.LoggerFactory

import scala.concurrent.duration._

/**
 * Performance test for the Phaser entity.
 */
class PhaserGatlingTest extends Simulation {

    val ip = System.getenv("NIT_SERV_PORT_8080_TCP_ADDR")
    val port = System.getenv("NIT_SERV_PORT_8080_TCP_PORT")

    val baseURL = s"http://$ip:$port"

    val httpConf = http
        .baseURL(baseURL)
        .inferHtmlResources()
        .acceptHeader("*/*")
        .acceptEncodingHeader("gzip, deflate")
        .acceptLanguageHeader("fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3")
        .connectionHeader("keep-alive")
        .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:33.0) Gecko/20100101 Firefox/33.0")

    val headers_http = Map(
        "Accept" -> """application/json"""
    )

    val headers_http_post = Map(
        "Content-Type" -> """application/json"""
    )

    val scn = scenario("Test the Phaser entity")
        .repeat(2) {
            exec(http("Get all Phasers")
            .get("/api/phasers")
            .headers(headers_http)
            .check(status.is(200)))
            .pause(5 seconds, 10 seconds)
            .exec(http("Create new Phaser")
            .post("/api/phasers")
            .headers(headers_http)
            .body(StringBody("""{"mass":1, "volume":1}""")).asJSON
            .check(status.is(201))
            .check(headerRegex("Location", "(.*)").saveAs("new_Phaser_url"))).exitHereIfFailed
            .pause(5)
            .repeat(5) {
                exec(http("Get created Phaser")
                .get(baseURL+"${new_Phaser_url}")
                .headers(headers_http))
                .pause(5)
            }
            .exec(http("Delete created Phaser")
            .delete("${new_Phaser_url}")
            .headers(headers_http))
            .pause(5)
        }

    val users = scenario("Users").exec(scn)

    setUp(
        users.inject(rampUsers(100) over (1 minutes))
    ).protocols(httpConf)
}
