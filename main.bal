import ballerina/http;
import ballerina/log;

final http:Client countriesClient = check new ("https://dev-tools.wso2.com/gs/helpers/v1.0/");

service / on new http:Listener(8080) {

    resource function get countries() returns CountryResponse[]|http:InternalServerError {
        do {

            // Sending a GET request to the "/countries" endpoint and retrieving an array of `Country` records.

            log:printInfo("fetching top countries");
            Country[] countries = check countriesClient->/countries;

            // Using a query expression to process the list of countries and generate a summary.
            CountryResponse[] topCountries =
                from var {name, continent, population, area, gdp} in countries
            where population >= 100000000 && area >= 1000000d // Filtering countries with a population >= 100M and area >= 1M sq km.
            let decimal gdpPerCapita = (gdp / population).round(2) // Calculating and rounding GDP per capita to 2 decimal places.
            order by gdpPerCapita descending // Sorting the results by GDP per capita in descending order.
            limit 10 // Limiting the results to the top 10 countries.
            select {name, continent, gdpPerCapita};
            log:printDebug(`fetched the countries list ${countries}`);
            // Selecting the country name, continent, and GDP per capita.
            return topCountries;
        } on fail var err {
            return <http:InternalServerError>{
                body: {
                    "error": "Failed to retrieve countries",
                    "message": err.message()
                }
            };
        }
    }
}
