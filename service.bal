import ballerinax/worldbank;
import ballerinax/covid19;
import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get status/[string countryName]() returns json | error {
        // Send a response back to the caller.

        covid19:Client covid19Ep = check new ();

        covid19:CovidCountry getStatusByCountryResponse = check covid19Ep->getStatusByCountry(country = countryName);
        int cases = <int>getStatusByCountryResponse.todayCases;
        worldbank:Client worldbankEp = check new ();
        worldbank:IndicatorInformation[] getPopulationByCountryResponse = check worldbankEp->getPopulationByCountry(countryCode = countryName);
        int populationInmillions = <int>(getPopulationByCountryResponse[0].value / 1000000);
        int casesPerMillion = cases / populationInmillions;
        json payload = {
            country: countryName,
            casesPerMillion: casesPerMillion
        };
        return payload;
    }
}
