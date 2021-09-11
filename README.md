# README

## Prerequisites

* Rails - 6.1.4.1
* Ruby - 2.7.4

## Installation Steps
* Clone this repo
* `cd` into the repo
* run `bundle install` to install dependencies
* Run  `rails db:create` to create the database
* Run `rails db:migrate` to create all the  necessary tables.
* Start the app by running `rails s`

## Tests
* Run `rspec spec` to run all the tests

## API documentation
* Run `rails s` and visit `http://localhost:3000/api-docs/index.html`

## Available Endpoints

* Add stock - `POST http://localhost:3000/api/v1/stocks`. Parameters - `{ name: string, bearer: string }`
* Update stock - `PATCH http://localhost:3000/api/v1/stocks/:id`. Parameters - `{ name: string, bearer: string }`
* Delete stock - `DELETE http://localhost:3000/api/v1/stocks/:id`
* Fetch all stocks - `GET http://localhost:3000/api/v1/stocks`


#### To improve

- Pagination is missing for index call
- Authorization by token is missing
- Migrate to RDBMS from SQlite