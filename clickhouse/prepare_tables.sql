
DESCRIBE url(
    'https://storage.googleapis.com/covid19-open-data/v3/epidemiology.csv',
    'CSVWithNames'
);



CREATE TABLE `default`.covid19 (
    date Date,
    location_key LowCardinality(String),
    new_confirmed Int32,
    new_deceased Int32,
    new_recovered Int32,
    new_tested Int32,
    cumulative_confirmed Int32,
    cumulative_deceased Int32,
    cumulative_recovered Int32,
    cumulative_tested Int32
)
ENGINE = MergeTree
ORDER BY (location_key, date);


INSERT INTO `default`.covid19
   SELECT *
   FROM
      url(
        'https://storage.googleapis.com/covid19-open-data/v3/epidemiology.csv',
        CSVWithNames,
        'date Date,
        location_key LowCardinality(String),
        new_confirmed Int32,
        new_deceased Int32,
        new_recovered Int32,
        new_tested Int32,
        cumulative_confirmed Int32,
        cumulative_deceased Int32,
        cumulative_recovered Int32,
        cumulative_tested Int32'
    );


DESCRIBE url(
    'https://storage.googleapis.com/covid19-open-data/v3/demographics.csv',
    'CSVWithNames'
);


CREATE TABLE `default`.demographics (
    location_key    String,
    population  Nullable(Int64),
    population_male Nullable(Int64),
    population_female   Nullable(Int64),
    population_rural    Nullable(Int64),
    population_urban    Nullable(Int64),
    population_largest_city Nullable(Int64),
    population_clustered    Nullable(Int64),
    population_density  Nullable(Float64),
    human_development_index Nullable(Float64),
    population_age_00_09    Nullable(Int64),
    population_age_10_19    Nullable(Int64),
    population_age_20_29    Nullable(Int64),
    population_age_30_39    Nullable(Int64),
    population_age_40_49    Nullable(Int64),
    population_age_50_59    Nullable(Int64),
    population_age_60_69    Nullable(Int64),
    population_age_70_79    Nullable(Int64),
    population_age_80_and_older Nullable(Int64)
)
ENGINE = MergeTree
ORDER BY (location_key);



INSERT INTO `default`.demographics
   SELECT *
   FROM
      url(
        'https://storage.googleapis.com/covid19-open-data/v3/demographics.csv',
        CSVWithNames,
        'location_key    String,
         population  Nullable(Int64),
         population_male Nullable(Int64),
         population_female   Nullable(Int64),
         population_rural    Nullable(Int64),
         population_urban    Nullable(Int64),
         population_largest_city Nullable(Int64),
         population_clustered    Nullable(Int64),
         population_density  Nullable(Float64),
         human_development_index Nullable(Float64),
         population_age_00_09    Nullable(Int64),
         population_age_10_19    Nullable(Int64),
         population_age_20_29    Nullable(Int64),
         population_age_30_39    Nullable(Int64),
         population_age_40_49    Nullable(Int64),
         population_age_50_59    Nullable(Int64),
         population_age_60_69    Nullable(Int64),
         population_age_70_79    Nullable(Int64),
         population_age_80_and_older Nullable(Int64)'
    );

