# **DATA_COLLECT for Lirias (elements cache API)**

This project is designed to collect and parse records for Lirias using the elements cache API. It leverages Docker for containerization and provides scripts for building and running the necessary services.

## Prerequisites

- Docker
- Docker Compose

## Setup

1. **Create an `.env` file**:
Ensure you have a `.env` file in the root directory with the following parameters:
```env
SERVICE=your_service_name
REGISTRY=your_registry
NAMESPACE=your_namespace
VERSION_TAG=your_version_tag
```

## Build the Docker image:
```ruby
docker-compose up -d --build
```

## Usage
Start collecting and parsing records
To start the data collection and parsing process, run:
```ruby
docker-compose run --rm lirias_collector
```

## Output
The output will always be written in the /records/ directory. You can use multiple Docker services with different volumes and/or config files to manage different data collection tasks. for example Daily updates vs full reload, or production vs test.

## Configuration
The configuration files are located in the config directory. The main configuration file is [config.yml](src\config\config.yml). You can customize the configuration by editing these files.

## Scripts
###### - Build script: build.sh This script builds the Docker image using the parameters defined in the .env file.

###### - Collector scripts: Located in the lib directory.
- lirias_collector.rb
    Collecting data based on last_run_updates, last_run_deletes, ... in config.yml
- lirias_collector_by_id_list.rb
    Collecting data with config.yml and lirias_ids.json as input parameters
- lirias_create_tar.rb
    Create tar-file of a temp-dir with records from a previous run that was terminated with Errors

## Testing
Use rake to run the tests.
example:
```
docker-compose run --rm lirias_collector_develop bash -c "cd /app/src/;rake test TEST=test/parsing_test.rb TESTOPTS="--name=test_oa -v"
```
## License
This project is licensed under the MIT License.