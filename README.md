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

You can check your installed versions using:
```
    ruby --version
    rails --version
    node --version
    yarn --version or npm --version
    psql --version
```

If any of the above tools are not installed, please make sure to install them before proceeding.

# Quick Start

### 1. Clone the repository

```
    git clone https://github.com/1212032/sunrise-sunset-app.git
```

Navigate into the project folder:
```
    cd sunrise-sunset-app
```

### 2. Install Dependencies

Install ruby gems
```
    bundle install
```
Install JavaScript packages (you can use either npm or Yarn):
```
    npm install 
    or
    yarn install
```

### 3. Database Setup

Start the PostgreSQL service:

```
    sudo service postgresql start
```
Create and migrate database:
```
    rails db:create
    rails db:migrate
```

### 4. Start Application

Start Rails server:
```
    rails server
```

Open your browser and navigate to:
```
    http://localhost:3000
```
### 5. Run Tests
To run the rails tests, use the following command:
```
    rspec spec
```

# Api Usage

The application provides a RESTful API endpoint:

```
    GET /api/v1/sunset_data
```

This endpoint retrieves sunrise and sunset data for a specific location and date range.

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
            "id": "16",
            "type": "sun_event",
            "attributes": {
                "date": "2025-08-01",
                "sunrise": "6:39:07 AM",
                "sunset": "8:49:04 PM",
                "golden_hour": "8:11:30 PM",
                "latitude": 38.7077507,
                "longitude": -9.1365919,
                "day_length": "14:09:56",
                "location": "Lisbon, Portugal",
                "timezone": "Europe/Lisbon"
            }
        },
        {
            "id": "17",
            "type": "sun_event",
            "attributes": {
                "date": "2025-08-02",
                "sunrise": "6:40:01 AM",
                "sunset": "8:48:04 PM",
                "golden_hour": "8:10:35 PM",
                "latitude": 38.7077507,
                "longitude": -9.1365919,
                "day_length": "14:08:03",
                "location": "Lisbon, Portugal",
                "timezone": "Europe/Lisbon"
            }
        }
    ]
}
```

# SunSetApp Usage

To use the application, simply fill out the form with the location, start date, and end date, then click "Get Data". 

![Sunrise Sunset App form](/imgs/SunriseSunsetForm.png)


The app will fetch the information from the server and display:

* Location details
* Sunrise and sunset times for the selected date range

![Sunrise Sunset App usage example](/imgs/SunriseSunsetUsage.png)

