public type Country record {
    string name;
    string continent;
    int population;
    decimal gdp;
    decimal area;
};

public type CountryResponse record {
    string name;
    string continent;
    decimal gdpPerCapita;
};