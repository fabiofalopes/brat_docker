# BRAT Rapid Annotation Tool Docker Setup

Set up and run the [BRAT Rapid Annotation Tool](https://github.com/nlplab/brat) using Docker.

## Prerequisites

- Docker and Docker Compose must be installed on your system.
- Internet connection is necessary to download BRAT.

## Setup Instructions

### Step 1: Initial Setup

Run the `setup_brat.sh` script to download and prepare the BRAT source code.

**This script will:**

1. Clone repo to directory to `brat`.
3. Create a text file (`brat_version_info.txt`) that contains the version information, download link, and extraction date/time.
4. Copy Docker-related configuration files into the newly created `brat` folder.

```bash
./setup_brat.sh
```

Note: setup_brat-old.sh was using the tar.gz directly instead of git clone repo

### Step 2: Install and Run BRAT

Run the `install_brat.sh` script to build and start the BRAT Docker container.

**This script will:**

1. Change the current directory to `brat`.
2. Build the Docker image using the `Dockerfile`.
3. Start the Docker container based on the configuration in `docker-compose.yml`.

```bash
./install_brat.sh
```

## Accessing BRAT

Once the Docker container is running, access the BRAT tool by opening your web browser and navigating to:

```
http://localhost:8066
```

## Additional Information

- [brat rapid annotation tool](https://brat.nlplab.org/)

- For detailed configuration options, refer to the `docs/brat-configuration.md` file.
- For more information on BRAT installation, check `docs/brat-instalation.md`.

Both refer to the website documentation.

## Troubleshooting

- Ensure Docker and Docker Compose are installed correctly.
- Verify Docker is running and check logs for errors using:

```bash
docker-compose logs
```

Deve funcar!
