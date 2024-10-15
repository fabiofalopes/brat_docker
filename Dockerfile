# Dockerfile

# Use an official Python 2.7 slim image
FROM python:2.7-slim

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apache2 \
        build-essential \
        python-dev \
        python3 \
        gcc \
        && \
    rm -rf /var/lib/apt/lists/*

# Enable necessary Apache modules
RUN a2enmod cgi rewrite

# Set environment variables
ENV BRAT_DIR /home/brat

# Set working directory
WORKDIR $BRAT_DIR

# Copy local BRAT files into the image
COPY . $BRAT_DIR

# Install Python dependencies
RUN pip install --no-cache-dir flup==1.0.2 simplejson==2.1.5 ujson==1.18

# Copy Apache configuration
COPY apache/brat.conf /etc/apache2/sites-available/

# Enable the BRAT site and disable the default site
RUN a2dissite 000-default.conf && \
    a2ensite brat.conf

# Configure `config.py`
RUN sed -i "s/CHANGE_ME/'admin@example.com'/g" config.py

# Set permissions for BRAT directories
RUN chown -R www-data:www-data $BRAT_DIR && \
    chmod -R 755 $BRAT_DIR

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
