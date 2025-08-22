# Welcome to Sunrise Sunset App

A React + Ruby on Rails application that displays the time of sunrise, sunset and sun golden hour for any location worldwide.

This project was **powered by the [SunriseSunset.io](https://sunrisesunset.io/) api** and to call the api we need to pass latitude and longitude, for that we used [geocoder](https://www.rubygeocoder.com/).

Powered by 

# Features 

* Search sunrise/sunset times by location name
* Date range selection (Start and end)
* Data visualization

# Prerequisites 

The app was developed using this versions:

* Ruby: 3.4.5
* Rails: 8.0.2.1
* Node.js: 18.19.1
* Yarn: 1.22.22
* PostgreSQL: 16.9

Check your current versions:

```
    ruby --version
    rails --version
    node --version
    yarn --version
    psql --version
```


# Quick Start

### 1. Clone the repository

```
    git clone https://github.com/1212032/sunrise-sunset-app.git
```

Get inside base project folder:
```
    cd sunrise-sunset-app
```

### 2. Install Dependencies

Install ruby gems
```
    bundle install
```
Install JavaScript packages
```
    yarn install
```

### 3. Database Setup

Start PostgreSQL service

```
    sudo service postgresql start
```
Create and migrate database
```
    rails db:create
    rails db:migrate
```

### 4. Start Application

Start Rails server
```
    rails server
```

Start Vite(React) dev server
```
    ./bin/vite dev
```
Access the aplication in your browser and navigate to:
```
    http://localhost:3000
```
### 5. Run Tests
To run the rails test's use the following command:
```
    rails test
```

# Api Usage

The application provides a RESTful API endpoint:

```
    GET /api/v1/sunset_data
```

Retrieve sunrise/sunset data for a location and date range.

Parameters: 

* Location(:string) - City or parish (ex: "London", "Porto")
* StartDate(:string) - Start date in YYYY-MM-DD format (ex: "2025-08-23")
* EndDate(:string) - End date in YYYY-MM-DD format (ex: "2025-08-24")

Request example: 

```
    GET /api/v1/sunset_data?location=Lisbon&start_date=2025-08-23&end_date=2025-08-24
```
Example response:
```
{
    "data": [
        {
        "date": "2024-01-01",
        "sunrise": "07:51:00",
        "sunset": "17:20:00",
        "golden_hour": "16:45:00",
        "day_length": "09:29:00"
        }
    ]
}
```



