# Geo Location API app
This application use geo_location gem to provide an interface to provide access to the geolocation data through API.

## Getting Started
This is a Geo Location API system. Try the following steps to run the app.

### Prerequisites
Assuming you have installed `git`, `ruby` and `rvm`.

## Running the programs

To start the program go to directory `location-api`

```
cd location-api
```

and exucute
```
gem install bundler
bundle install
```

Copy config/database.yml.example to config/database.yml for database config

Now copy the migration and edit it to add columns if required and create and migrate database
```
rails generate geo_location:geodata:geo_location_data
rake db:create db:migrate
```

Then import the data:
```
rake geo_location:geodata:geolite:insert file=tmp/data_dump.csv
```

then start the server:
```
rails s
```

to run test cases
```
bundle exec rspec
```


## API Endpoints

Our API will expose the following RESTful endpoints.

| Endpoint | Functionality |
| --- | --- |
| GET /locations | List all locations |
| GET /search?q='1.1.1.1' | Location list according to search criteria |
| POST /locations | Create a new location with given params |
| GET /locations/:id | Get location details |
| PUT /locations/:id | Update a location |
| DELETE /locations/:id | Delete a location |

### Search API Endpoints

| Endpoint | Functionality |
| --- | --- |
| GET /search?q=10.10.10.10 | Get location with '10.10.10.10' ip |
| GET /search?q=112.32,546.77 | Locations with latitude 112.32 and longitude 546.77 |
| GET /search?q=city1 | Locations with city name city1 |
| GET /search?q=country1 | Locations with country name country1 |
| GET /search?q=city1,city2,country1 | Locations with city name city1 or city2 or country name country1 |


#### This which can be included:
authorizing all API requests making sure that all requests have a valid token and user payload.
we can use some search engine like solr or elastic if data size became large


