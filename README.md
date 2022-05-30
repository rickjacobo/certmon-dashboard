# certmon-dashboard

## Requirements
- Container Platform
  - running rickjacobo/certmon
- MySql Database

## Setup
### Docker Example
* Run Docker Command
````
docker run -d -e ENV_SQL_HOSTNAME="<hostname>" -e ENV_SQL_USERNAME="<username>" -e ENV_SQL_PASSWORD="<password>" -e ENV_SQL_DATABASE="<database>" -e ENV_SQL_TABLE="<table>" --name certmon-dashboard -p 80:80 rickjacobo/certmon-dashboard
````
